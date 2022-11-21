Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D318632B78
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 18:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiKURvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 12:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKURvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 12:51:18 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D41D2887
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 09:51:17 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y203so12010455pfb.4
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 09:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RhAYFXLIQS2qzqEcnPTGyFvoB7XVIT1zAlrBiS9X3as=;
        b=l9dgayGmBp69vNWuCME0DkDszXhtX5YuYBFfiY16JZGw6bpUAC7pOD03pf7xQY1P6E
         LDNQDKTVqfidj8enF+srWG7HVLGFHaGkBLPVqgkQ9/4yfHoWz1U1dcAfLs8vx3xdbBDx
         Yj9uX7QeAlpfubC8g5u86M9QrX6i9JyC+Fl9FeUMKb9BvWRnttr5lPBHSuROZJoyOkgT
         yfD1JcGKuz4JK46/upSl0QuofIUxcsF6luxDen/MhpWsEqPg29fo0OYa3ZOSbIHPpA+U
         xtyb0vKqyLC1hta4+sKdU0isvvEtaYEuw/wUHGjHtzSAkuZ+YYp7iRfgoZxKnuCByEoZ
         gqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RhAYFXLIQS2qzqEcnPTGyFvoB7XVIT1zAlrBiS9X3as=;
        b=DMMSlzersZH70UHt5umcbNPqCuKMKPHsEX9eFtiNg5IiTxkyoaqGmh+GGNGW6dTlX2
         cHMk73fXKoJgqbBAj+LeBbGp/Z4G6FIWPAk8je09ySw6Sirsy0CxlgFuYzrVHIHZc5GY
         wWBhqfMX3nu4kUZp96SbgfJ1hA9LUqOmDb6KtUWY5Aia57crcvHoAk4T2oetbRkKoYiU
         Zg9S7GDAQDCY897vGwYA7dPYyt7n4H8OSz+8Pr4atlfJn02WWj4PQLe+dF+cSdzOKFFS
         VckfRg6xuJ/4MWUTADNA6ph2CinoqJf98hYoTRUJejk3rQq2s1nPgoIXyHCLLOFevjOu
         kCQA==
X-Gm-Message-State: ANoB5plVS3M2MQ2YPY/xWwGGPgcvZKHktNADnWunQAlbcZ4HdGJNXgVB
        uwLDaGlmKe2TBqnBr69Y5cEdsA==
X-Google-Smtp-Source: AA0mqf4zbrRm6t9sW6mILJI3b+8h2EDBi9Wk9wnZueOJJ4cszbyjNqjD6c+83T0HSgmaYbvYqoTUgw==
X-Received: by 2002:a63:4b16:0:b0:476:d0b8:1117 with SMTP id y22-20020a634b16000000b00476d0b81117mr18320733pga.104.1669053076443;
        Mon, 21 Nov 2022 09:51:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ms17-20020a17090b235100b00218b8f8af91sm1956111pjb.48.2022.11.21.09.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 09:51:16 -0800 (PST)
Date:   Mon, 21 Nov 2022 17:51:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH 02/13] KVM: nSVM: don't call
 nested_sync_control_from_vmcb02 on each VM exit
Message-ID: <Y3u6kCUKuq3VYUc0@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-3-mlevitsk@redhat.com>
 <Y3aT5qBgOuwsOeS/@google.com>
 <3829b20beeeed8ec2480eada30b2639b07bc579e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3829b20beeeed8ec2480eada30b2639b07bc579e.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022, Maxim Levitsky wrote:
> On Thu, 2022-11-17 at 20:04 +0000, Sean Christopherson wrote:
> > On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> > > Calling nested_sync_control_from_vmcb02 on each VM exit (nested or not),
> > > was an attempt to keep the int_ctl field in the vmcb12 cache
> > > up to date on each VM exit.
> > 
> > This doesn't mesh with the reasoning in commit 2d8a42be0e2b ("KVM: nSVM: synchronize
> > VMCB controls updated by the processor on every vmexit"), which states that the
> > goal is to keep svm->nested.ctl.* synchronized, not vmcb12.  Or is nested.ctl the
> > cache you are referring to?
> 
> Thanks for digging that commit out.
> 
> My reasoning was that cache contains both control and 'save' fields, and
> we don't update 'save' fields on each VM exit.
>
> For control it indeed looks like int_ctl and eventinj are the only fields
> that are updated by the CPU, although IMHO they don't *need* to be updated
> until we do a nested VM exit, because the VM isn't supposed to look at vmcb
> while it is in use by the CPU, its state is undefined.

The point of the cache isn't to forward info to L2 though, it's so that KVM can
query the effective VMCB state without having to read guest memory and/or track
where the current state lives.

> For migration though, this does look like a problem. It can be fixed during
> reading the nested state but it is a hack as well.
>
> My idea was as you had seen in the patches it to unify int_ctl handling,
> since some bits might need to be copied to vmcb12 but some to vmcb01,
> and we happened to have none of these so far, and it "happened" to work.
> 
> Do you have an idea on how to do this cleanly? I can just leave this as is
> and only sync the bits of int_ctl from vmcb02 to vmcb01 on nested VM exit.
> Ugly but would work.

That honestly seems like the best option to me.  The ugly part isn't as much KVM's
caching as it is the mixed, conditional behavior of int_ctl.  E.g. VMX has even
more caching and synchronization (eVMCS, shadow VMCS, etc...), but off the top of
my head I can't think of any scenarios where KVM needs to splice/split VMCS fields.
KVM needs to conditionally sync fields, but not split like this.

In other words, I think this particular code is going to be rather ugly no matter
what KVM does.
