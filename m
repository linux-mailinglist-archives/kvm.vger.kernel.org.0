Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B896E3571
	for <lists+kvm@lfdr.de>; Sun, 16 Apr 2023 08:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjDPGgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Apr 2023 02:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDPGga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Apr 2023 02:36:30 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5606211F;
        Sat, 15 Apr 2023 23:36:28 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4eb3b71a3f6so503478e87.1;
        Sat, 15 Apr 2023 23:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681626987; x=1684218987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3L5M9tYO6kwhg4avzAfSUb8EGYOSjY/7OoWA3kBaXwQ=;
        b=lFfE5Z/Jq7I1JbAsOLZOlraWUg9dg2vDrx6DkFyf1qlbZkoFjINhAFRmK9xDHiFOIR
         PXqY0yciNtFNQQqzX/mu2zNiGtLb8NdTEhpc+Q1ViJKSS7ouHM4oa97VMdGUXOcgq+F8
         lw7aTlqAKQA45Ka+X2ZBY0YeD6CxvXsdGzbDR3d06AgL6QR+lhPLjDcru2CkBYGPsj3w
         BWJCyy+FB6eCHh0fK71GUjZnjbd/FYQlBFnxrL10MquD306CExNzJitQhgqrPKwhiHyi
         dY4JWmpvBy1+dLyMUAm7LFXMxUJOhurpfB4RM3jzg/MB6KkGtpHwiYYuQFBQv1WR5mBw
         IDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681626987; x=1684218987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3L5M9tYO6kwhg4avzAfSUb8EGYOSjY/7OoWA3kBaXwQ=;
        b=HKC3Uxvawm1kR/TUfWuZuWaNYPTp16Lw7LxuMDkocU3oXma1Fz/bRjGvPrwP0HNrGd
         szBMrNl3/3QbiNO7zfMVoKIYwz5oa8eSOR7FHbiUal/xWG491kbyRQyNYhN/8ThIxh39
         +VJQnI6Hh1P7oVPzZeNOk84xayIjouQE8cKEx0Fv6XlYXtU69CDQdGYRBX/ca6tXNO4I
         iIQu0+dBlvCX6LK1l+aZoTgMglzJpmDrwexNgu/V8uEZ0Tlz1u3ecNtcdlCgaNJSNpa5
         mhaan1dfat5Fa5weRqxfCF67ZtzdZPwlPnKgorgpbIXRGxChPBlSl55zqIhQ5dXkn6dI
         t4SA==
X-Gm-Message-State: AAQBX9cIzfoqSU9hqNdlmBQm3O9InFMqR+P4tdQukqgEAyOwuEN1b5kn
        19FG7XXfj4BG5rSxGLwLUlo=
X-Google-Smtp-Source: AKy350ZXd3ThHphHyItvDQskq1ntFHPKe4z+eY/fUpIfNegCM5qX3kTOn2R828VsrbKYMJVOQ+ckzw==
X-Received: by 2002:ac2:5506:0:b0:4ec:89d3:a89d with SMTP id j6-20020ac25506000000b004ec89d3a89dmr1556982lfk.4.1681626986997;
        Sat, 15 Apr 2023 23:36:26 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id o10-20020a05651238aa00b004cb43c9bf9asm1589724lft.208.2023.04.15.23.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 23:36:26 -0700 (PDT)
Date:   Sun, 16 Apr 2023 09:36:25 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Message-ID: <20230416093625.00005a68.zhi.wang.linux@gmail.com>
In-Reply-To: <23aa3eb68362648f1fab41954728a47dfadd9c61.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
        <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
        <ZC4qF90l77m3X1Ir@google.com>
        <20230406130119.000011fe.zhi.wang.linux@gmail.com>
        <e1e7a37a29c2c7ad22cd14181f24b06088eca451.camel@intel.com>
        <ZDbMuZKhAUbrkrc7@google.com>
        <ae28ce9b0c78a926c38a8c8b9694aa34b140b467.camel@intel.com>
        <ZDiGpCkXOcCm074O@google.com>
        <23aa3eb68362648f1fab41954728a47dfadd9c61.camel@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Apr 2023 13:42:11 +0000
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-04-13 at 15:48 -0700, Sean Christopherson wrote:
> > On Thu, Apr 13, 2023, Kai Huang wrote:
> > > On Wed, 2023-04-12 at 08:22 -0700, Sean Christopherson wrote:
> > > > KVM's uAPI for initiating TDH.MNG.INIT could obviously filter out
> > > > unsupported leafs, but doing so would lead to potential ABI breaks, e.g. if a leaf
> > > > that KVM filters out becomes known to the TDX Module, then upgrading the TDX Module
> > > > could result in previously allowed input becoming invalid.
> > > 
> > > How about only filtering out PV related CPUIDs when applying CPUIDs to
> > > TDH.MNG.INIT?  I think we can assume they are not gonna be known to TDX module
> > > anyway.
> > 
> > Nope, not going down that road.  Fool me once[*], shame on you.  Fool me twice,
> > shame on me :-)
> 
> Ah OK :)
> 
> > 
> > Objections to hardware vendors defining PV interfaces aside, there exist leafs
> > that are neither PV related nor known to the TDX module, e.g. Centaur leafs.  I
> > think it's extremely unlikely (understatement) that anyone will want to expose
> > Centaur leafs to a TDX guest, but again I want to say out of the business of
> > telling userspace what is and isn't sane CPUID models.
> 
> Right.  There might be use case that TDX guest wants to use some CPUID which
> isn't handled by the TDX module but purely by KVM.  We don't want to limit the
> possibility.  Totally agree.
> 
> > 
> > [*] https://lore.kernel.org/all/20221210160046.2608762-6-chen.zhang@intel.com
> > 
> > > > Even if that weren't the case, ignoring KVM_SET_CPUID{2} would be a bad option
> > > > becuase it doesn't allow KVM to open behavior in the future, i.e. ignoring the
> > > > leaf would effectively make _everything_ valid input.  If KVM were to rely solely
> > > > on TDH.MNG.INIT, then KVM would want to completely disallow KVM_SET_CPUID{2}.
> > > 
> > > Right.  Disallowing SET_CPUID{2} probably is better, as it gives userspace a
> > > more concrete result.  
> > > 
> > > > 
> > > > Back to Zhi's question, the best thing to do for TDX and SNP is likely to require
> > > > that overlap between KVM_SET_CPUID{2} and the "trusted" CPUID be consistent.  The
> > > > key difference is that KVM would be enforcing consistency, not sanity.  I.e. KVM
> > > > isn't making arbitrary decisions on what is/isn't sane, KVM is simply requiring
> > > > that userspace provide a CPUID model that's consistent with what userspace provided
> > > > earlier.
> > > 
> > > So IIUC, you prefer to verifying the CPUIDs in SET_CPUID{2} are a super set of
> > > the CPUIDs provided in TDH.MNG.INIT?  And KVM manually verifies all CPUIDs for
> > > all vcpus are consistent (the same) in SET_CPUID{2}?
> > 
> > Yes, except KVM doesn't need to verify vCPUs are consistent with respect to each
> > other, just that each vCPU is consistent with respect to what was reported to the
> > TDX Module.
> 
> OK.  Fine to me.

I did some investigations and I think this approach would work on both TDX
and SNP, as both of them can let a CC guest handle the firmware-not-aware CPUID
in #VE or #VC. E.g. KVM paravirt CPUIDs. And we can factor out and re-use the
"checking-CPUID-is-equal" in KVM_SET_CPUID{2}. But I think TDX needs to
filter out the firmware-not-aware CPUIDs in TDH.MNG.INIT to pass the check?
(SNP firmware can adjust them automatically). I attached some details I found
in case you are interested in digging.

For TDX, KVM provides a CPUID table in TDH.MNG.INIT, and there are two polices
for the following CPUID virtualization: 1) TDX-module handle the CPUID
interception from a TD guest and emulated according to the CPUID table in
TDH.MNG.INIT. If TDX-module doesn't know this CPUID, #VE is injected 2) A TD
guest can request to handle the CPUID by itself via calling TDG.VP_CPUIDVE_SET.
Then a CPUID TD exit will be forwarded to the guest as #VE. The code snippet
of TDX module handling TD CPUID exit can be found here[1].

For SNP, userspace provides a CPUID table in SNP_LAUNCH_UPDATE with
PAGE_TYPE_CPUID. PSP will check and validate the CPUID in the table. It will be
part of the SNP metadata secrets, and passed to the guest later. A guest can
refer to the validated CPUID table when handling CPUID #VC, but can also handle
CPUIDs not in the table[2] (e.g. paravirt CPUID).


[1] https://downloadmirror.intel.com/738876/tdx-module-v1.0.01.01.zip/src/td_dispatcher/vm_exits/td_cpuid.c
[2] https://github.com/AMDESE/linux-svsm/blob/main/src/cpu/vc.rs#L571
> 
> > 
> > > Looks this is over-complicated, _if_ the "only filtering out PV related CPUIDs
> > > when applying CPUIDs to TDH.MNG.INIT" approach works. 
> > 
> > It's not complicated at all.  Walk through the leafs defined during TDH.MNG.INIT,
> > reject KVM_SET_CPUID if a leaf isn't present or doesn't match exactly.  Or has
> > the TDX spec changed and it's no longer that simple?
> 
> No the module hasn't been changed, and yes it should be as simple as you said. 
> I just had some first impression that handling CPUID in one IOCTL (TDH.MNG.INIT)
> should be simpler than handling CPUID in two IOCTLs, but I guess this might not
> be true :)
> 
> Anyway I agree with your suggestion.  Thanks.
> 
