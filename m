Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0E3631FFF
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 12:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiKULNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 06:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiKULNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 06:13:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3635FB962F
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 03:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669028864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xNuyVgSMX/ajeMNmF/4b1DUvMDeMPy/4E3AU3e3kKQU=;
        b=Umn8//K3nYL4KXuX8y8STDk+2f1kbQS6GOSMWekPKhgtWHE3+aF/CFjnkcIBblC+/jySR3
        FTvfeTuoc5biJyhaiQjaisSAuHGVcW2worj+8PGz38AkPO0Q97FZWfbFr2T5Hm4Y5Z2DNL
        mvcthJrRzZW2/s2JYmjP5AGzMixR2QQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-eSj-xaqyPUqPpu4m6eCf-g-1; Mon, 21 Nov 2022 06:07:42 -0500
X-MC-Unique: eSj-xaqyPUqPpu4m6eCf-g-1
Received: by mail-wm1-f72.google.com with SMTP id c187-20020a1c35c4000000b003cfee3c91cdso6328767wma.6
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 03:07:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xNuyVgSMX/ajeMNmF/4b1DUvMDeMPy/4E3AU3e3kKQU=;
        b=mBUD55DK763xnxTnEkNapzlUDZRxQ+Q+1cCoueTJLJn8/Yop3Mryx+q7TpZME/IO+x
         ttcCq3XuC52pC0ohHsqbnbL7fYPqRY5GYveTdh7GP4tqQPMWI1huwb+oAOWwx1zpg5KB
         RyNGFAvueYyduSIRMHu8wh09s40U7Vl/BAdDP7/GmA1+sxXvdQjCDF1QERB4Uk7Gq12J
         imqG8hqfB9ZbzW8SIwphkscokxHoSJ8+PQf2fyTWq9n+rKVobaJoqchu0sOtpunAnhDg
         hU4x5wqj84cT4MKMWe4C2ImgvzSFU1zqjAmbhoXDVJleH7blUfD8kuq8VP/6PRXcXImz
         5ujA==
X-Gm-Message-State: ANoB5pmEd/a40nofJ4eC/r5kZH4XR/B6uETh0V4ZrkL9YdT1A96/mdw7
        WIxdER33GPGUYbS1FmhTu5jf9cc3dRT9r5WhFKYg1pwXTtc75gW3/vmRBH0auUqguxyuYw2Kkzv
        9JDbccFkDPP+n
X-Received: by 2002:adf:fb12:0:b0:236:60e8:3cca with SMTP id c18-20020adffb12000000b0023660e83ccamr4505601wrr.471.1669028861413;
        Mon, 21 Nov 2022 03:07:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Tx2y2Y1smXnHRhOhJ81J74U3+HhoNnCAbQfBkdFVjvc7NuYnBWQPVlTYlY79K73/EmsGh9Q==
X-Received: by 2002:adf:fb12:0:b0:236:60e8:3cca with SMTP id c18-20020adffb12000000b0023660e83ccamr4505590wrr.471.1669028861101;
        Mon, 21 Nov 2022 03:07:41 -0800 (PST)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id a13-20020a5d53cd000000b002383edcde09sm10878550wrw.59.2022.11.21.03.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 03:07:40 -0800 (PST)
Message-ID: <3829b20beeeed8ec2480eada30b2639b07bc579e.camel@redhat.com>
Subject: Re: [PATCH 02/13] KVM: nSVM: don't call
 nested_sync_control_from_vmcb02 on each VM exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
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
Date:   Mon, 21 Nov 2022 13:07:38 +0200
In-Reply-To: <Y3aT5qBgOuwsOeS/@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
         <20221117143242.102721-3-mlevitsk@redhat.com> <Y3aT5qBgOuwsOeS/@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-17 at 20:04 +0000, Sean Christopherson wrote:
> On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> > Calling nested_sync_control_from_vmcb02 on each VM exit (nested or not),
> > was an attempt to keep the int_ctl field in the vmcb12 cache
> > up to date on each VM exit.
> 
> This doesn't mesh with the reasoning in commit 2d8a42be0e2b ("KVM: nSVM: synchronize
> VMCB controls updated by the processor on every vmexit"), which states that the
> goal is to keep svm->nested.ctl.* synchronized, not vmcb12.  Or is nested.ctl the
> cache you are referring to?

Thanks for digging that commit out.

My reasoning was that cache contains both control and 'save' fields, and
we don't update 'save' fields on each VM exit.

For control it indeed looks like int_ctl and eventinj are the only fields
that are updated by the CPU, although IMHO they don't *need* to be updated
until we do a nested VM exit, because the VM isn't supposed to look at vmcb while it
is in use by the CPU, its state is undefined.

For migration though, this does look like a problem. It can be fixed during
reading the nested state but it is a hack as well.

My idea was as you had seen in the patches it to unify int_ctl handling,
since some bits might need to be copied to vmcb12 but some to vmcb01,
and we happened to have none of these so far, and it "happened" to work.

Do you have an idea on how to do this cleanly? I can just leave this as is
and only sync the bits of int_ctl from vmcb02 to vmcb01 on nested VM exit.
Ugly but would work.




> 
> > However all other fields in the vmcb12 cache are not kept up to  date,
> 
> IIUC, this isn't technically true.  They are up-to-date because they're never
> modified by hardware.

In both save and control cache. In control cache indeed looks like the
fields are kept up to date.

Best regards,
	Maxim Levitsky

> 
> > therefore for consistency it is better to do this on a nested VM exit only.
> 
> Again, IIUC, this actually introduces an inconsistency because it leaves stale
> state in svm->nested.ctl, whereas the existing code ensures all state in
> svm->nested.ctl is fresh immediately after non-nested VM-Exit.
> 


