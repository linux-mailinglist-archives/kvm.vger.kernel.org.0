Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288722A9C09
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 19:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgKFS1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 13:27:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbgKFS1Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 13:27:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604687235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uLWpUlEdRJJ9RglmDP2JiH2Rw8ed2aV7oLUITGGVqGE=;
        b=Wgp9/xhpljv2qWvzyizwjyTLjgT0Pyo1Un6142GY7t5S7aKngDXdoWYjJVuHzCxZhQ4nr5
        9VKdHmi1znehAzf8ofyEcAWEHenelImlNqyhj7SOuD7+1PUYeptRpjbCVAZV7McLKoET/U
        OQ/BmzCeXGu1vGStCprTKUPYEZteRVU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-PX9hT1sTMY-a8TsNGNXDEA-1; Fri, 06 Nov 2020 13:27:13 -0500
X-MC-Unique: PX9hT1sTMY-a8TsNGNXDEA-1
Received: by mail-qv1-f70.google.com with SMTP id q19so1197692qvs.5
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 10:27:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uLWpUlEdRJJ9RglmDP2JiH2Rw8ed2aV7oLUITGGVqGE=;
        b=XtxgJbG+Yh/+bUhSgp5yV8O95NOEPCk8B3VdgDcVHFClQBb7S8InnTtlEZn1FXHwX3
         bJJcrjzgnWyfzuUspUpWWE3a7k58jI43MAyBHVS+VFrJ/fyueUAUxeFK23iUtTjwqK7I
         f3JhWRUarmlk/pCjMX9TkcBEeC6Zj6qoOnqBRkMuhyoi/XKHAjKppn/3wsyemUr6hK3E
         Y//fdmsaCxbP1KJuo6omNGA1DwMLsnPl8es/HR6uDiJuEYfgzafENqrVgcAsAygA/j3+
         ZYdLMa7LYwM54bqPgK56m0Kig7pqtFr/eODfmLhxWv/PxPH1GXaTajDCcfuYIklqkoOv
         xzEg==
X-Gm-Message-State: AOAM532qyIUvme8m+TLW2Wgf7cHaq9BE2wBu2T+1t3XQjY4WfubBJc5c
        j1h1VprUv94fGTlcgzHM7MUPoPDSvKOnsleNcPO31Gb74EJ7if1sungc1vOOvLMonoO77OC0GmY
        UznXT4hACB2u7
X-Received: by 2002:ad4:42c8:: with SMTP id f8mr2250324qvr.29.1604687233170;
        Fri, 06 Nov 2020 10:27:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHhkhIZKp/u0Pe1HDC5P8CPhOgezTVWU4OVzzWul7iGDH2sPQ/aZM/pkgfoX8wLdX9Ct2B9Q==
X-Received: by 2002:ad4:42c8:: with SMTP id f8mr2250303qvr.29.1604687232973;
        Fri, 06 Nov 2020 10:27:12 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id z13sm1094305qkl.2.2020.11.06.10.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 10:27:12 -0800 (PST)
Date:   Fri, 6 Nov 2020 13:27:10 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v13 13/14] KVM: selftests: Let dirty_log_test async for
 dirty ring test
Message-ID: <20201106182710.GF138364@xz-x1>
References: <20201001012044.5151-1-peterx@redhat.com>
 <20201001012239.6159-1-peterx@redhat.com>
 <6d5eb99e-e068-e5a6-522f-07ef9c33127f@redhat.com>
 <20201106180610.GC138364@xz-x1>
 <dc32ce97-cbd2-07da-b8ca-30ea67c2d4e3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dc32ce97-cbd2-07da-b8ca-30ea67c2d4e3@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06, 2020 at 07:15:31PM +0100, Paolo Bonzini wrote:
> On 06/11/20 19:06, Peter Xu wrote:
> > > +	pthread_sigmask(0, NULL, sigset);
> > Not extremely important, but still better with SIG_BLOCK imho, since it seems
> > not all archs defined SIG_BLOCK as zero.
> > 
> 
> If the second argument is NULL, the first is unused.

Oh OK!

-- 
Peter Xu

