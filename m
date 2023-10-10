Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B3B7C443C
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 00:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjJJWgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 18:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbjJJWfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 18:35:53 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCB1EB
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 15:27:52 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-537f07dfe8eso2250a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 15:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696976870; x=1697581670; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=68I4/kUJYE4Jd0IkluAbz0Ui3D9rGGNXovNsQX6uI5I=;
        b=gXCZZAZQcpFyfvXqVq8U2OT0AX7EehYLdf2XL1JI8BHUZeCnOgQ/yaUkSLHjEOfxF0
         RgbyXgNKP12sYJkn0sqayNbO8DIPuP0AYCmTW1t2UUeZzgUn6+81LENEEnlqLzgdUjwS
         AaYr+cl5At2SbJkL9Me66mMdTh5vpolJKd4OS9j2IrwAkFcqYIz5MBifPoehAT9+nYAL
         WpS0txj+JS4n1d8WAHnpaYCb0gd1MmBKATyEXsUZHiablKQ9pIGopJLm5+Tg395iVBLo
         XJUr4SmZpEQjO3IONP87ovlZyyi5YEzqnP8pFIKvCjB1fEzoQISeu1s9fNQ3tuzJkB2P
         lXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696976870; x=1697581670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=68I4/kUJYE4Jd0IkluAbz0Ui3D9rGGNXovNsQX6uI5I=;
        b=ByB4FbANyyxulbxaiRTymA8A09tv7cboXoucpSf/l6bwyyTSbli90VLU6d94jAcRAF
         RDgYDoQYmcQBvUKM4V2IE9pD3+U/PobJrbdq4CQDF6l26ApMLja/7x2H8K/4iutm7p4k
         Igmmc2+7Bb6LX4gCVLlM+Aif3uSUwRSaKZsceh/9ES4z4KdKsrR9kEB2mMC9hBd4r6Gp
         P1pKszzYJRXZUJostaycCUGHNKzIzoPMGcV9+ZPY2bDXmAPe2nHYujhnGHQj6PV6eHj/
         4BD918RQCVepgyHt/s89cW97hZ7WVpd+FuI89Ply0kggjA4SqPWUkWdTkL3Mw6JTbGC9
         S+yQ==
X-Gm-Message-State: AOJu0YxmK0m5MAnPTRb1lwUwY5k2IdfICzOlXA+RdtbzNPolib4cZjQp
        sML5HT0hA8BMkugQ75flinj4pnTkS/6qQahyHNwDUA==
X-Google-Smtp-Source: AGHT+IGny594a9XsCjHdt6nL/bGrVGpGcKwwcBGsw7oPTWq1gDcm8DJKT5Br1nftZP4YGGeHN5czVcMgpHg04v3JOqY=
X-Received: by 2002:a50:9356:0:b0:538:1d3b:172f with SMTP id
 n22-20020a509356000000b005381d3b172fmr21737eda.3.1696976870475; Tue, 10 Oct
 2023 15:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <b46ee4de968733a69117458e9f8f9d2a6682376f.camel@infradead.org>
In-Reply-To: <b46ee4de968733a69117458e9f8f9d2a6682376f.camel@infradead.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Oct 2023 15:27:35 -0700
Message-ID: <CALMp9eQNX_NmUqaiYP=CygTwt1TRug1+00bNfFiH-ugqVY_F1g@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: Don't wipe TDP MMU when guest sets %cr4
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        "Szczepanek, Bartosz" <bsz@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 2:37=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> If I understand things correctly, the point of the TDP MMU is to use
> page tables such as EPT for GPA =E2=86=92 HPA translations, but let the
> virtualization support in the CPU handle all of the *virtual*
> addressing and page tables, including the non-root mode %cr3/%cr4.
>
> I have a guest which loves to flip the SMEP bit on and off in %cr4 all
> the time. The guest is actually Xen, in its 'PV shim' mode which
> enables it to support a single PV guest, while running in a true
> hardware virtual machine:
> https://lists.xenproject.org/archives/html/xen-devel/2018-01/msg00497.htm=
l
>
> The performance is *awful*, since as far as I can tell, on every flip
> KVM flushes the entire EPT. I understand why that might be necessary
> for the mode where KVM is building up a set of shadow page tables to
> directly map GVA =E2=86=92 HPA and be loaded into %cr3 of a CPU that does=
n't
> support native EPT translations. But I don't understand why the TDP MMU
> would need to do it. Surely we don't have to change anything in the EPT
> just because the stuff in the non-root-mode %cr3/%cr4 changes?
>
> So I tried this, and it went faster and nothing appears to have blown
> up.
>
> Am I missing something? Is this stupidly wrong?

The TDP MMU is essentially a virtual TLB of guest-physical mappings,
so it's oblivious to %cr4 changes. However, the hardware TLBs of the
current logical processor contain combined mappings, which may have to
be flushed, depending on how %cr4 has changed. Since kvm has emulated
the instruction, it is responsible for flushing the hardware TLBs as
required (see the SDM, volume 3, section 4.10.4: Operations that
Invalidate TLBs and Paging-Structure Caches). Some of the logic in
kvm_post_set_cr4() seems to deal with that.

Not your fault, of course, but can't we come up with a better name
than "kvm_post_set_cr4"?
