Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC48B6E06B3
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 08:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDMGHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 02:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMGHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 02:07:10 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B8D4EFD;
        Wed, 12 Apr 2023 23:07:08 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4eca9c8dd57so27504e87.1;
        Wed, 12 Apr 2023 23:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681366027; x=1683958027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+jl2LZuEAFtS9zMp6EpJ1KnP4j914ngxP5uVncQweg=;
        b=cw0akD+AoIiKabjnRbCgexjolcpcvYdtKzzm28l9hy/fQfYNMjQhnrwOO9msg4wxYd
         iZTiuq5rKXVlhKqLAbtV9lwMUQ30+GhPMtGI3jyy5rAslxMO1zCWxzLak3ZQSKhHNtr9
         8mJJDiW26t0S8Zi39fuVcCCL9sj+uN/lQZNQR1lqbPZM+xF/MUF1jgLfHB+1ouUfgrn8
         a6HStO0gzfLKvthtR/16lGm+0Ih66GZbvFE+jxM8688Ie52ApIKxgFmffoSPZIRk0Vvo
         ptmvjbo08FTDZNv3VCfx/GQ53p2I7rdru49Vy6cV6TWkz3x09VRrsYw9vVeW6episrst
         9YoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681366027; x=1683958027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+jl2LZuEAFtS9zMp6EpJ1KnP4j914ngxP5uVncQweg=;
        b=IteWgVf3ZiRaXrQ2Bga42bUpBegu40tIv2qy/Mx+zVLs8dGfbu4c6tzsjh8L5si4Nz
         //FmEAH55BsFgCvQwVBSUwy043oEjcCXucVZ2RtZTluaNSXpexdqhTpVoBNhuhvjdBxT
         uO0I8Ex60HpNuahZJgnkpddDOlBW9aXAINFx3PdRB9uYG8EEhKcabRLg5i9fhfGHQaux
         ebbT8j44FQ1zf7vKvIDMcQ6xwexWu7cM5AIDbyl3nJ4sZ09o61jVTiDFheVRoI1ejd79
         Xty+LwgPNIe7nOxS8U+cYMt7U6d4l84DCR/2Ikp6EvcT3nSnaFHB6aQ5v0jVUStdDbqi
         DwnA==
X-Gm-Message-State: AAQBX9d47LVfb71c9HgxRiA5PIcNPqXXUVLZe7wjyFbNFpqoK03mCOyy
        2jw/jQpKY646U9f8QOaT6NXqsckvzSE=
X-Google-Smtp-Source: AKy350ZXnLCgunmYyDc3KU4RwH/pvLVPA87FAEL/b2XDE9ZSGl3pBRfJBbI+fqKEz5eb2zxubloLAw==
X-Received: by 2002:a05:651c:50a:b0:2a7:805e:b0e6 with SMTP id o10-20020a05651c050a00b002a7805eb0e6mr483136ljp.2.1681366026707;
        Wed, 12 Apr 2023 23:07:06 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id a23-20020a2e8317000000b002a79d7ceb93sm116515ljh.9.2023.04.12.23.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 23:07:06 -0700 (PDT)
Date:   Thu, 13 Apr 2023 09:07:03 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Message-ID: <20230413090703.00002690.zhi.wang.linux@gmail.com>
In-Reply-To: <e1e7a37a29c2c7ad22cd14181f24b06088eca451.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
        <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
        <ZC4qF90l77m3X1Ir@google.com>
        <20230406130119.000011fe.zhi.wang.linux@gmail.com>
        <e1e7a37a29c2c7ad22cd14181f24b06088eca451.camel@intel.com>
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

On Wed, 12 Apr 2023 12:07:13 +0000
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-04-06 at 13:01 +0300, Zhi Wang wrote:
> > On Wed, 5 Apr 2023 19:10:40 -0700
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > On Wed, Apr 05, 2023, Huang, Kai wrote:
> > > > On Tue, 2023-04-04 at 17:59 -0700, Sean Christopherson wrote:
> > > > > *** WARNING *** ABI breakage.
> > > > > 
> > > > > Stop adjusting the guest's CPUID info for the allowed XFRM (a.k.a. XCR0)
> > > > > for SGX enclaves.  Past me didn't understand the roles and responsibilities
> > > > > between userspace and KVM with respect to CPUID leafs, i.e. I thought I was
> > > > > being helpful by having KVM adjust the entries.
> > > > 
> > > > Actually I am not clear about this topic.
> > > > 
> > > > So the rule is KVM should never adjust CPUID entries passed from userspace?
> > > 
> > > Yes, except for true runtime entries where a CPUID leaf is dynamic based on other
> > > CPU state, e.g. CR4 bits, MISC_ENABLES in the MONITOR/MWAIT case, etc.
> > > 
> > > > What if the userspace passed the incorrect CPUID entries?  Should KVM sanitize
> > > > those CPUID entries to ensure there's no insane configuration?  My concern is if
> > > > we allow guest to be created with insane CPUID configurations, the guest can be
> > > > confused and behaviour unexpectedly.
> > > 
> > > It is userspace's responsibility to provide a sane, correct setup.  The one
> > > exception is that KVM rejects KVM_SET_CPUID{2} if userspace attempts to define an
> > > unsupported virtual address width, the argument being that a malicious userspace
> > > could attack KVM by coercing KVM into stuff a non-canonical address into e.g. a
> > > VMCS field.
> > > 
> > > The reason for KVM punting to userspace is that it's all but impossible to define
> > > what is/isn't sane.  A really good example would be an alternative we (Google)
> > > considered for the "smaller MAXPHYADDR" fiasco, the underlying problem being that
> > > migrating a vCPU with MAXPHYADDR=46 to a system with MAXPHYADDR=52 will incorrectly
> > > miss reserved bit #PFs.
> > > 
> > > Rather than teach KVM to try and deal with smaller MAXPHYADDRs, an idea we considered
> > > was to instead enumerate guest.MAXPHYADDR=52 on platforms with host.MAXPHYADDR=46 in
> > > anticipation of eventual migration.  So long as userspace doesn't actually enumerate
> > > memslots in the illegal address space, KVM would be able to treat such accesses as
> > > emulated MMIO, and would only need to intercept #PF(RSVD).
> > > 
> > > Circling back to "what's sane", enumerating guest.MAXPHYADDR > host.MAXPHYADDR
> > > definitely qualifies as insane since it really can't work correctly, but in our
> > > opinion it was far superior to running with allow_smaller_maxphyaddr=true.
> > > 
> > > And sane is not the same thing as architecturally legal.  AMX is a good example
> > > of this.  It's _technically_ legal to enumerate support for XFEATURE_TILE_CFG but
> > > not XFEATURE_TILE_DATA in CPUID, but illegal to actually try to enable TILE_CFG
> > > in XCR0 without also enabling TILE_DATA.  KVM should arguably reject CPUID configs
> > > with TILE_CFG but not TILE_DATA, and vice versa, but then KVM is rejecting a 100%
> > > architecturally valid, if insane, CPUID configuration.  Ditto for nearly all of
> > > the VMX control bits versus their CPUID counterparts.
> > > 
> > > And sometimes there are good reasons to run a VM with a truly insane configuration,
> > > e.g. for testing purposes.
> > > 
> > > TL;DR: trying to enforce "sane" CPUID/feature configuration is a gigantic can of worms.
> > 
> > Interesting point. I was digging the CPUID virtualization OF TDX/SNP.
> > It would be nice to have a conclusion of what is "sane" and what is the
> > proper role for KVM, as firmware/TDX module is going to validate the "sane"
> > CPUID.
> > 
> > TDX/SNP requires the CPUID to be pre-configured and validated before creating
> > a CC guest. (It is done via TDH.MNG.INIT in TDX and inserting a CPUID page in
> > SNP_LAUNCH_UPDATE in SNP).
> > 
> > IIUC according to what you mentioned, KVM should be treated like "CPUID box"
> > for QEMU and the checks in KVM is only to ensure the requirements of a chosen
> > one is literally possible and correct. KVM should not care if the combination, the usage of the chosen ones is insane or not, which gives QEMU flexibility.
> > 
> > As the valid CPUIDs have been decided when creating a CC guest, what should be
> > the proper behavior (basically any new checks?) of KVM for the later
> > SET_CPUID2? My gut feeling is KVM should know the "CPUID box" is reduced
> > at least, because some KVM code paths rely on guest CPUID configuration.
> 
> For TDX guest my preference is KVM to save all CPUID entries in TDH.MNG.INIT and
> manually make vcpu's CPUID point to the saved CPUIDs.  And then KVM just ignore
> the SET_CPUID2 for TDX guest.
> 
> Not sure whether AMD counterpart can be done in similar way though. 

I took a look on AMD SNP kernel[1], it supports host managing the CPUID
and firmware managing the CPUID. The host-managed CPUID is done via a GHCB
message call and it is going to be removed according to the SNP firmware ABI
spec:

7.1 CPUID Reporting
Note: This guest message may be removed in future versions as it is redundant with the CPUID page in SNP_LAUNCH_UPDATE. (See Section 8.17.)

So the style of CPUID virtualization of TDX and SNP will be aligned eventually.
Both will configure the supported CPUID for the firmware/TDX module before
creating a vCPU. 

[1] https://github.com/AMDESE/linux/blob/upmv10-host-snp-v8-rfc/arch/x86/kvm/svm/sev.c
[2] https://www.amd.com/system/files/TechDocs/56860.pdf
