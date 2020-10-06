Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1012284D17
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 16:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgJFOFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 10:05:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbgJFOFW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 10:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601993121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=guYki50KQJdFnn1PZrjvoH399zUlc+hngMckBoejkYs=;
        b=R6LMBXqwxzERPXPuelGyMjmp50cHieZjPIXRX6c6ec2/4kMHeEp8X1cVz5yVzT5Ei0tzxA
        wg2hc09OVD8xg1urLfxuYbc7if8OEAX01Qw26Ff1Rl3MoRzZ/wQLyP6AIcyJkyseZD64zT
        vZuV2+qg9ZITJh2t7PDn6aZypaydvRQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-o15JCWokMey_H0zi-6KKbQ-1; Tue, 06 Oct 2020 10:05:20 -0400
X-MC-Unique: o15JCWokMey_H0zi-6KKbQ-1
Received: by mail-wm1-f71.google.com with SMTP id f2so737031wml.6
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 07:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=guYki50KQJdFnn1PZrjvoH399zUlc+hngMckBoejkYs=;
        b=XmI7UikdgEPkC2SgyYS3eBcYwzzt5bI7oS3P18FdkA/NFXpFt+w4Qhtwm0iUll0QWf
         4z4186KtkK9cXo+gxSI3PglNj80xFjZl+UiTsUogQTmaaI0IWlkUPtEJvi69Z7Isoa0S
         iMpsD4GxFiXlx2HkxQcZNZghKoViPTNfGTVDnJae+mWQel1oPVR/yAscyd8ktqbt3RNS
         An5NL4krOjTj3DRXUoydWFouQrtptkCeBDMmIJ/7eGT6aFkYVAWTYepZaxjJM22B047w
         qAjdfwe/0WMD8aj71vkDkjzzDDHGiqsocUZ6j3pOyL8rbvMBmerxwmGWRKgFuHTa28ik
         JJaQ==
X-Gm-Message-State: AOAM532T3OyKgRSKqg42XfE5HkCzCxiOrm4ju28m/OfAnxnLsw0MWWul
        zxs9rKON5wlfgc/1iP3Ox7AP/P8hSKJlVEeRo3SNmCUPDcyrl3sH3+oaplQnlEs719UtuevVs/h
        UyOxSCAAgwynO
X-Received: by 2002:a1c:417:: with SMTP id 23mr4967685wme.1.1601993118923;
        Tue, 06 Oct 2020 07:05:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOa4DTQCDzLceiEFkj8shvvubVqqzvW5y8izKrSxstNeZxCY/TaDjcROYTZ8pPRTzplS32LQ==
X-Received: by 2002:a1c:417:: with SMTP id 23mr4967661wme.1.1601993118732;
        Tue, 06 Oct 2020 07:05:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q20sm3953461wmc.39.2020.10.06.07.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 07:05:17 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
In-Reply-To: <20201006134629.GB5306@redhat.com>
References: <20201001215508.GD3522@redhat.com> <20201001223320.GI7474@linux.intel.com> <20201002153854.GC3119@redhat.com> <20201002183036.GB24460@linux.intel.com> <20201002192734.GD3119@redhat.com> <20201002194517.GD24460@linux.intel.com> <20201002200214.GB10232@redhat.com> <20201002211314.GE24460@linux.intel.com> <20201005153318.GA4302@redhat.com> <20201005161620.GC11938@linux.intel.com> <20201006134629.GB5306@redhat.com>
Date:   Tue, 06 Oct 2020 16:05:16 +0200
Message-ID: <877ds38n6r.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> A. Just exit to user space with -EFAULT (using kvm request) and don't
>    wait for the accessing task to run on vcpu again. 

What if we also save the required information (RIP, GFN, ...) in the
guest along with the APF token so in case of -EFAULT we can just 'crash'
the guest and the required information can easily be obtained from
kdump? This will solve the debugging problem even for TDX/SEV-ES (if
kdump is possible there).

-- 
Vitaly

