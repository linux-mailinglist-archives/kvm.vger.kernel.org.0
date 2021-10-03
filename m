Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC71420385
	for <lists+kvm@lfdr.de>; Sun,  3 Oct 2021 21:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhJCTE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Oct 2021 15:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhJCTE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Oct 2021 15:04:57 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CD6C0613EC
        for <kvm@vger.kernel.org>; Sun,  3 Oct 2021 12:03:09 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id m3so61778618lfu.2
        for <kvm@vger.kernel.org>; Sun, 03 Oct 2021 12:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ow30GBGQA1FAf/xboEkwAx7IjJ8fqjrJnjZ63QrUg98=;
        b=PsVtQSWnnY/4YamDEyNsnpVIzr5MUbSbCWQPZ/ppZWC9x8MYs8QH53oXmI93For3ux
         R7iK+U0wKzxNwOj4vl+zEWfx77R1rzeCHRXMDa0CZ05gVBKEF6AYgPv0t7q8j3rD1DUe
         ldhnswIxr5U/ECr0CCiNTXBFY6GNcgOX+yVfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ow30GBGQA1FAf/xboEkwAx7IjJ8fqjrJnjZ63QrUg98=;
        b=qIovEpARQSJj+3DVQAjK/Lpe067jj1SVwiJhuVG99VvQcZtNpUtkyRg5+NBsdr67/2
         IOe/C5o+YXesSsqOJXMX8c7n4DO/MYrfdqyYALCm9ZQFlJYxDpj+5rnkcZN8TzsOM8Cy
         IRTmzLBI+l0qXSmxUQBKp0HSCiEuRMhCQrODMd56Y9pV9hIk5F3j2bQX/lL3DtxXBUXO
         qsv6s+Ph1MGVQYypLiM0UuoJrGXgKrlJOeFjxZy1ayiaGBqtGBfMqZX/ko3isE3xtuHh
         oTfsj1FN0MpPvhi4bajPeaFB7JFFa51x/NkP/5kNA+buf4YPVHz9N6scA6HohjI5SxG3
         waag==
X-Gm-Message-State: AOAM530R3dRrPYVYcpgBGzYYVDJmz0VycVxU3gtqJkPZTVox1dGYW/lz
        Nv+qjcZkyw6yXuXGnx6jXyBtx1TkuZsODuJU
X-Google-Smtp-Source: ABdhPJwtbFDGf7e0RyCgrt4MVsQPBCUi3uH+B1gjEL+JLzMi2bEB94GrXw6cG+PKj78rxnnSznyNfw==
X-Received: by 2002:a05:651c:154a:: with SMTP id y10mr10961346ljp.103.1633287786951;
        Sun, 03 Oct 2021 12:03:06 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id d9sm1353150ljc.28.2021.10.03.12.03.05
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 12:03:06 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id u18so62510335lfd.12
        for <kvm@vger.kernel.org>; Sun, 03 Oct 2021 12:03:05 -0700 (PDT)
X-Received: by 2002:ac2:58cb:: with SMTP id u11mr5355853lfo.402.1633287785686;
 Sun, 03 Oct 2021 12:03:05 -0700 (PDT)
MIME-Version: 1.0
References: <YVl7RR5NcbPyiXgO@zn.tnic> <CAHk-=wh9JzLmwAqA2+cA=Y4x_TYNBZv_OM4eSEDFPF8V_GAPug@mail.gmail.com>
In-Reply-To: <CAHk-=wh9JzLmwAqA2+cA=Y4x_TYNBZv_OM4eSEDFPF8V_GAPug@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 3 Oct 2021 12:02:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiZwq-0LknKhXN4M+T8jbxn_2i9mcKpO+OaBSSq_Eh7tg@mail.gmail.com>
Message-ID: <CAHk-=wiZwq-0LknKhXN4M+T8jbxn_2i9mcKpO+OaBSSq_Eh7tg@mail.gmail.com>
Subject: Re: [GIT PULL] objtool/urgent for v5.15-rc4
To:     Borislav Petkov <bp@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000048555d05cd77728a"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000048555d05cd77728a
Content-Type: text/plain; charset="UTF-8"

On Sun, Oct 3, 2021 at 11:38 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Looking at the kvm code, that kvm_fastop_exception thing is some funky sh*t.
>
> I _think_ the problem is that 'kvm_fastop_exception' is done with bare
> asm at the top-level and that triggers some odd interaction with other
> section data, but I really don't know.

No, it's the fact that it is marked as a global function (why?) that
it then causes problems.

Now, I don't actually see why it would cause problems (the same way I
don't see why it's marked global). But removing that

     ".global kvm_fastop_exception \n"

works.

I suspect it makes the linker do the relocation for us before objtool
runs, because now that it's a local name, there is no worry about
multiply defined symbols of the same name or anything like that.

I also suspect that the reason for the warning is that the symbol type
has never been declared, so it's not marked as a STT_FUNC in the
relocation information.

So independently of this kvm_fastop_exception issue, I'd suggest the
attached patch for objtool to make the warning more informative for
people who try to debug this.

So I have a fix ("remove the global declaration"), but I really don't
like how random this is.

I also tried to instead keep the symbol global, and just mark
kvm_fastop_exception as a function (and add the proper size
annotation), but that only causes more objtool warnings for the
(generated asm) functions that *use* that symbol. Because they also
don't seem to be properly annotated.

Again, removing the global annotation works around the problem, but
the real underlying issue does seem to be that "funky sh*t" going on
in arch/x86/kvm/emulate.c.

So I'd like more people to look at this.

In the meantime, I think the exception handling for kvm
divide/multiply emulation is badly broken right now. Hmm?

                Linus

--00000000000048555d05cd77728a
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kubl14rm0>
X-Attachment-Id: f_kubl14rm0

IHRvb2xzL29ianRvb2wvc3BlY2lhbC5jIHwgMTIgKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3Rvb2xzL29i
anRvb2wvc3BlY2lhbC5jIGIvdG9vbHMvb2JqdG9vbC9zcGVjaWFsLmMKaW5kZXggZjU4ZWNjNTBm
YjEwLi5mMTQyOGUzMmE1MDUgMTAwNjQ0Ci0tLSBhL3Rvb2xzL29ianRvb2wvc3BlY2lhbC5jCisr
KyBiL3Rvb2xzL29ianRvb2wvc3BlY2lhbC5jCkBAIC0xMTAsOCArMTEwLDEwIEBAIHN0YXRpYyBp
bnQgZ2V0X2FsdF9lbnRyeShzdHJ1Y3QgZWxmICplbGYsIHN0cnVjdCBzcGVjaWFsX2VudHJ5ICpl
bnRyeSwKIAkJcmV0dXJuIC0xOwogCX0KIAlpZiAoIXJlbG9jMnNlY19vZmYob3JpZ19yZWxvYywg
JmFsdC0+b3JpZ19zZWMsICZhbHQtPm9yaWdfb2ZmKSkgewotCQlXQVJOX0ZVTkMoImRvbid0IGtu
b3cgaG93IHRvIGhhbmRsZSByZWxvYyBzeW1ib2wgdHlwZTogJXMiLAotCQkJICAgc2VjLCBvZmZz
ZXQgKyBlbnRyeS0+b3JpZywgb3JpZ19yZWxvYy0+c3ltLT5uYW1lKTsKKwkJV0FSTl9GVU5DKCJk
b24ndCBrbm93IGhvdyB0byBoYW5kbGUgcmVsb2Mgc3ltYm9sIHR5cGUgJWQ6ICVzIiwKKwkJCSAg
IHNlYywgb2Zmc2V0ICsgZW50cnktPm9yaWcsCisJCQkgICBvcmlnX3JlbG9jLT5zeW0tPnR5cGUs
CisJCQkgICBvcmlnX3JlbG9jLT5zeW0tPm5hbWUpOwogCQlyZXR1cm4gLTE7CiAJfQogCkBAIC0x
MzIsOCArMTM0LDEwIEBAIHN0YXRpYyBpbnQgZ2V0X2FsdF9lbnRyeShzdHJ1Y3QgZWxmICplbGYs
IHN0cnVjdCBzcGVjaWFsX2VudHJ5ICplbnRyeSwKIAkJCXJldHVybiAxOwogCiAJCWlmICghcmVs
b2Myc2VjX29mZihuZXdfcmVsb2MsICZhbHQtPm5ld19zZWMsICZhbHQtPm5ld19vZmYpKSB7Ci0J
CQlXQVJOX0ZVTkMoImRvbid0IGtub3cgaG93IHRvIGhhbmRsZSByZWxvYyBzeW1ib2wgdHlwZTog
JXMiLAotCQkJCSAgc2VjLCBvZmZzZXQgKyBlbnRyeS0+bmV3LCBuZXdfcmVsb2MtPnN5bS0+bmFt
ZSk7CisJCQlXQVJOX0ZVTkMoImRvbid0IGtub3cgaG93IHRvIGhhbmRsZSByZWxvYyBzeW1ib2wg
dHlwZSAlZDogJXMiLAorCQkJCSAgc2VjLCBvZmZzZXQgKyBlbnRyeS0+bmV3LAorCQkJCSAgbmV3
X3JlbG9jLT5zeW0tPnR5cGUsCisJCQkJICBuZXdfcmVsb2MtPnN5bS0+bmFtZSk7CiAJCQlyZXR1
cm4gLTE7CiAJCX0KIAo=
--00000000000048555d05cd77728a--
