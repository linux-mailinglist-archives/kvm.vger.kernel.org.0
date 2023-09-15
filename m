Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0527A17A8
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 09:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjIOHmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 03:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbjIOHmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 03:42:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 235D71BD1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 00:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694763689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ovJMK9GrilbjwX/0y7+mnCgJGmzw3Nr5NlskEa/lZDc=;
        b=HVAWHNVcZzAvwdfcabRxWs10HhA1NsE6sUk9rKkBgQGe1GbLoUQR4znPembk8NF6SOvNtz
        rRlQ0NT9O/B8YzYvPsAVBs4saHeIzgcQlY57LN7qK8nY0q3SVJME/O31qs3yKpmGbfT5e7
        V3UMs5b0/zFXduQJz1x7GkNSjAblH3Y=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-UA5oqjvfP2i8IEsScoMVLQ-1; Fri, 15 Sep 2023 03:41:27 -0400
X-MC-Unique: UA5oqjvfP2i8IEsScoMVLQ-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-573527fcca1so2399339eaf.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 00:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694763686; x=1695368486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ovJMK9GrilbjwX/0y7+mnCgJGmzw3Nr5NlskEa/lZDc=;
        b=okw4gflN7Zid2gM0WCxGkMnQJR0AYPWy96SQB1HpBAH77i5u6uAdsK1czVElo7tNNT
         +Z/NEXdqoUhCwSXypybWBRIyEISdFtgqMpR++M7i55FGmbnhqvFI2l25evJXNboNcDmU
         kNinr1lT5nSRP/JKsAA2EpFWADFeHNs8K46PMX19BsLugLMwxKOYulW+51GiT8o6mGfa
         HM+2TIcR5gzCy1snTavs892Lvqq7f1bjWB3c4J1DCLcY14lk4d2B+uPlkRFnHhcgRB09
         zGu8TZq5c4P0qRx86XDhQiuqwxex1QYtMCyg2eKEhMS0rdxn6GKEjQEYfjiDhSY99uM0
         JURg==
X-Gm-Message-State: AOJu0YwLWkGinOGnmUhhM6XQ0NJRZTBcl9rf1S0YdVxrNbH0+q/Iol01
        3wG4vJ940nbc3wb6ODHVE52ix/1MiCC6bIWndQRv5FP6s64lncCmtN5RXKUnr+aUeRWXzKcpBE4
        b6nMPNyQOdhC8
X-Received: by 2002:a4a:7652:0:b0:573:f620:ec80 with SMTP id w18-20020a4a7652000000b00573f620ec80mr921811ooe.2.1694763686662;
        Fri, 15 Sep 2023 00:41:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZ36StU+OLLbiTLn2e1HMORaLyCJT5Ubwlj6Yrdptj0Bnukx6gd9OIIFfyZaGbk53Jz3ZDiQ==
X-Received: by 2002:a4a:7652:0:b0:573:f620:ec80 with SMTP id w18-20020a4a7652000000b00573f620ec80mr921799ooe.2.1694763686457;
        Fri, 15 Sep 2023 00:41:26 -0700 (PDT)
Received: from redhat.com ([2804:1b3:a803:4ff9:7c29:fe41:6aa7:43df])
        by smtp.gmail.com with ESMTPSA id v6-20020a9d7d06000000b006b9cbad68a8sm1399416otn.30.2023.09.15.00.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 00:41:25 -0700 (PDT)
Date:   Fri, 15 Sep 2023 04:41:20 -0300
From:   Leonardo Bras <leobras@redhat.com>
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dgilbert@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        bp@alien8.de, Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Message-ID: <ZQQKoIEgFki0KzxB@redhat.com>
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com>
 <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com>
 <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 08:58:42PM -0400, Tyler Stachecki wrote:
> On Thu, Sep 14, 2023 at 10:05:57AM -0700, Dongli Zhang wrote:
> > That is:
> > 
> > 1. Without the commit (src and dst), something bad may happen.
> > 
> > 2. With the commit on src, issue is fixed.
> > 
> > 3. With the commit only dst, it is expected that issue is not fixed.
> > 
> > Therefore, from administrator's perspective, the bugfix should always be applied
> > no the source server, in order to succeed the migration.
> 
> I fully agree. Though, I think this boils down to:
> The commit must be on the source or something bad may happen.
> 
> It then follows that you cannot live-migrate guests off the source to patch it
> without potentially corrupting the guests currently running on that source...

Well, the bug was a real bad issue, and even the solution does not solve 
all problems.

As we discussed, there is no way of safely removing any feature from the 
guest without potential issues. One potential solution would be having 
hosts that implement the missing guest features needed for the VMs, but 
this may be far from easy depending on the missing feature.

Other than that, all I can think of is removing the features from guest:

As you commented, there may be some features that would not be a problem 
to be removed, and also there may be features which are not used by the 
workload, and could be removed. But this would depend on the feature, and 
the workload, beind a custom solution for every case.

For this (removing guest features), from kernel side, I would suggest using 
SystemTap (and eBPF, IIRC). The procedures should be something like:
- Try to migrate VM from host with older kernel: fail
- Look at qemu error, which features are missing?
- Are those features safely removable from guest ? 
  - If so, get an SystemTap / eBPF script masking out the undesired bits.
  - Try the migration again, it should succeed.

IIRC, this could also be done in qemu side, with a custom qemu:
- Try to migrate VM from host with older kernel: fail
- Look at qemu error, which features are missing?
- Are those features safely removable from guest ?
  - If so, get a custom qemu which mask-out the desired flags before the VM 
    starts
  - Live migrate (can be inside the source host) to the custom qemu
  - Live migrate from custom qemu to target host.
- The custom qemu could be on a auxiliary host, and used only for this

Yes, it's hard, takes time, and may not solve every case, but it gets a 
higher chance of the VM surviving in the long run.

But keep in mind this is a hack.
Taking features from a live guest is not supported in any way, and has a 
high chance of crashing the VM.


Best regards,
Leo

> 
> Regards,
> Tyler
> 

