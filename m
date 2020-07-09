Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA87321A71F
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 20:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGISfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 14:35:02 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59461 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726163AbgGISfB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 14:35:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594319699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EU1/67mbdfMyDlz60KRLq5w/dPZq2hK6rVBVl3uxrNI=;
        b=SqUgwGFIlS21egAsr8ihKsfGOehH0jj5E1Q91cP7Yc+Da/kkmIOutit4aMzMdOsY1mY3Zc
        TEo5ALactnPwpQRFPwdsL7fs1eEzdY8VoRGWs4PzVayXJkUSye9vmaNqTuYKajJX6PFCnP
        PuTbbj1nId5pVeHneswTbKcSCg1tsNY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-VIpn1Im1PB2_1hGKFjFlNw-1; Thu, 09 Jul 2020 14:34:58 -0400
X-MC-Unique: VIpn1Im1PB2_1hGKFjFlNw-1
Received: by mail-qt1-f198.google.com with SMTP id g6so2306714qtr.0
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 11:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EU1/67mbdfMyDlz60KRLq5w/dPZq2hK6rVBVl3uxrNI=;
        b=soiyRvPx40VSC/D9edDJ11PnMCXKfpzr7PuKpz7s5aDoAmzVL29g5ht6TvWnaFYYqa
         L/4xsI4dSiezwQgarsduAmiH4NwATdLk3mfRa4FwmIq0pVtGjRgXpPjZtfY1qKytXq3Y
         eKLK8U5dMQmL4jYfhSVbn3repvT0iOZGlJ5fr2176YKKtkRScWuQExuuyYsaeuLK6p7R
         vdGqug3a3jrDJOsvh0YucTXSSaUynjbqRF6PCLgdG4hTXgxdL1xucVRUy/yTB77v8p38
         iUuXxIiNG0pZKIAydhYLx8YVS4lUnP+SlA15SzKAfMAeRtwHL79F43oastp8B6y0hprI
         sBBw==
X-Gm-Message-State: AOAM532ffl1pmsMIMUXuljrNyA16s0iaz8o9Rrn9KjHiQK3bOOwSvcjB
        ikhD9F27+NQcpwL8hx+uOqZMaxq6r5OimIyZNG+6xUnWsoQo37yYeKDs48RGhubPrlNrIZJtSdF
        IdnRDWfRjuCKZ
X-Received: by 2002:a05:620a:1659:: with SMTP id c25mr64295815qko.501.1594319697346;
        Thu, 09 Jul 2020 11:34:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvWvjoZ4lE7qQwT0Y7t3XSgFiCSmcOFc3Gqd8/zvCLCogqnE8+8DR/VbohjLVbxFl3mNlcWw==
X-Received: by 2002:a05:620a:1659:: with SMTP id c25mr64295796qko.501.1594319697150;
        Thu, 09 Jul 2020 11:34:57 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id x23sm4388205qki.6.2020.07.09.11.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:34:56 -0700 (PDT)
Date:   Thu, 9 Jul 2020 14:34:54 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200709183454.GH199122@xz-x1>
References: <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
 <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
 <20200630154726.GD7733@linux.intel.com>
 <20200709182220.GG199122@xz-x1>
 <7aa46e68-5780-2698-67f5-425693478fe1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7aa46e68-5780-2698-67f5-425693478fe1@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 09, 2020 at 08:24:03PM +0200, Paolo Bonzini wrote:
> On 09/07/20 20:22, Peter Xu wrote:
> >>> So I think Peter's patch is fine, but (possibly on top as a third patch)
> >>> __must_check should be added to MSR getters and setters.  Also one
> >>> possibility is to return -EINVAL for invalid MSRs.
> > Yeah I can add another patch for that.  Also if to repost, I tend to also
> > introduce KVM_MSR_RET_[OK|ERROR] too, which seems to be cleaner when we had
> > KVM_MSR_RET_INVALID.
> 
> You can use either that or 0/1/-EINVAL.  I would be fine with that to
> keep the patch small.

Yeah -EINVAL looks good.  Then, do you want me to s/1/-EFAULT/ altogether?

-- 
Peter Xu

