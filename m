Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FCF6A625B
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjB1WXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjB1WW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:22:59 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5250729F;
        Tue, 28 Feb 2023 14:22:58 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id o3so8017124qvr.1;
        Tue, 28 Feb 2023 14:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677622978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZE57a5Q7cevIW+oZ/qW06TAdkckdM2hI05ReZ7VUik=;
        b=dCu8D8SK0+21a+PbGvxo9GsyliZuT8jhbmvFoWzHvrfhLkdP+8XG25erywa7OZm2Wd
         3+fxmwU0E+mRhuxfylr/tUoacWJqnnRILYORlKREwyRtciwwfsndM2C8boiGgJtmYEo3
         ljl9f6aQyqt+Va/P/M+VBnW2toA20cbzpCRqfI5zTQPAQmvtsaO6QVmnw69M1GU93iM0
         cJh3cqmL3YK2Fici7GdxditcyEW9pPZ24kN+QYqbGYw/4A+mBFz83Qc6B402dUheFEcq
         5nq7AF+OLAhUIw+KXi1CSzLhZ8p93M9rN5HwI9FmmlYwSXH1N0fMbholrsINX2yxk4cx
         fk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677622978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ZE57a5Q7cevIW+oZ/qW06TAdkckdM2hI05ReZ7VUik=;
        b=wB0U8dYiJCFKDSlsMsB4VsTP3/ZudgmcM2F1+veCcc9c33BCIWwboEjMhqyIekVjiM
         iGF/QDCFm2/VJUhtKuVEoHnLjTxoIK/ZHQdss5cY9f6Oz8fVDXBAbMhg4I85Enuw1E0B
         Q1ch4Tm2rMIeg0vmQ2swjHM8yM+pcM0QotAAywH4S6o70utyicE1XoPlZCe1rWUIKajF
         bRItMU5UT+slsHN20qoDYytX4bnYTduS3/PqVqwmSjMGVi1ed7m8EaC/jgPTssGB+NiV
         ePtk3AGHF3aZWckEFofBw8xSoYFy3QTONE1sjkFtamyC7xQbC28xOJxWe3ViA1GqrE9z
         5rMg==
X-Gm-Message-State: AO0yUKW/UzIllqx+O26tqCpszOZ0S1xqd1+vIxTS4qxBjEjkXdT7ssTb
        F+v3biRPAkJvfzXp/EmUyaPK4JD28oQ8zD8Ikw==
X-Google-Smtp-Source: AK7set/W3LAQa6AzRMHio/n4h8MUG601awgIfKip+CkXzz0exIuCCw0uUaQOfc1tiY5Z5+hC2LX3u2NHwb4giLDJsCk=
X-Received: by 2002:a05:6214:948:b0:56e:96c3:e0f0 with SMTP id
 dn8-20020a056214094800b0056e96c3e0f0mr1245049qvb.0.1677622977753; Tue, 28 Feb
 2023 14:22:57 -0800 (PST)
MIME-Version: 1.0
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-7-usama.arif@bytedance.com> <87k001n4xo.ffs@tglx>
In-Reply-To: <87k001n4xo.ffs@tglx>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Tue, 28 Feb 2023 17:22:46 -0500
Message-ID: <CAMzpN2iBjzKxrqG97ck8wUh-jViDJCOUcqE02gA3g_BiDBA2Ug@mail.gmail.com>
Subject: Re: [PATCH v12 06/11] x86/smpboot: Remove initial_stack on 64-bit
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 11:13=E2=80=AFAM Thomas Gleixner <tglx@linutronix.d=
e> wrote:
>
> On Sun, Feb 26 2023 at 11:07, Usama Arif wrote:
> > From: Brian Gerst <brgerst@gmail.com>
> >
> > Eliminating global variables from the CPU startup path in order to simp=
lify
> > it and facilitate parallel startup.
>
> As this patch is now part of the parallel boot series and actually
> introduces smpboot_control, the above is neither accurate nor useful.
>
> Folks, really.
>
> > Remove initial_stack, and load RSP from current_task->thread.sp instead=
.
>
>
> >  #ifdef CONFIG_SMP
> > -     initial_stack =3D (unsigned long)temp_stack + sizeof(temp_stack);
> > +     current->thread.sp =3D (unsigned long)temp_stack + sizeof(temp_st=
ack);
>
> This lacks a comment about the temporary (ab)use of current->thread.sp

task->thread.sp represents the saved stack pointer of a sleeping or
newly forked task (see __switch_to_asm()), and the boot cpu's idle
task is effectively going to sleep.  Using a temporary stack for
resume is kind of a hack to workaround the fact that the idle task
stack is in use already, but improving that is out of scope for this
series.

--
Brian Gerst
