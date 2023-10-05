Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2E77BA95C
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 20:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjJESqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 14:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjJESqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 14:46:36 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C9693
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 11:46:34 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-57ba2cd3507so731749eaf.2
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 11:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696531594; x=1697136394; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2VPf19ilHtAD+Owv0i7z4J+SpXRejSHrhSqcq1CMBKM=;
        b=Do8n1ndZS0fZktImym9APZajUTmnwD0pLlPpBn+hccT2Le8Cn3r4QXvdUcJI5mbGoM
         LZo5jvwWRNEM5Z2z/PARWbWoPBOkPOD1DW3GQePSxlsiWFSlpEQsftyp+29yz2ZkB4SK
         SPaPLUi+vS5ftXo7d50O2T+Z0enpINCE+G0qtQY/f4tnFHgnHvMowBcCdv2tWXW8sHtB
         iks21dVcrUZp4vwWNYFu83sqTP0+r8iItH7kgIzLkEX5q+pBt81kmGuF4+DW4AppmQ/t
         jm4x5E2Ta8lAoQg1O8fQS6pSR39RSrzNOtjM34RVK3ppTKDBWHEBsa6BhL4Wg3Lfp5Ja
         OiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696531594; x=1697136394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2VPf19ilHtAD+Owv0i7z4J+SpXRejSHrhSqcq1CMBKM=;
        b=RzISYovyLVBm7nPmcVvun8toJ/rj92ZI47TF/jBnwr1NBdchiLzyuDdO0Mb6F+lzF3
         GJq+rZNnP98qIwKFIK1GmDcPdP4Jp1Jr/Hpf9ik1P4ZPM6NAj0SuV0GSgPbHVrxoHLy5
         ReLRPGJ3HItKRzRc/JQ3KCaR4SENp2iNUNbCQTp5Kx4R2zNv+pV4Xvm2G6UWPMV8/J4l
         zMhVnIK6++tMcRRv50PD+Vl860E/CsApjN/IFYGKnju+7nPCszZRDuwDY4FAROSC7jJG
         jVcN519KFoy/KpiKAbiKOaUR9fmo40lvQvljc/v5mcy4q9dCGoo5XbpuXcAY071KFQVm
         Gg3A==
X-Gm-Message-State: AOJu0YwqGLuHn3G6gAlKI66nhz8gsu+l6N0Bo5ny5OrIdm0SB8oq19wT
        uct4vAe0dz/pVAvPakMta49rP59r229XLw+wHXHoOQ==
X-Google-Smtp-Source: AGHT+IGM/D0+4k30Jd6fhOvSgxFV+GVUeOTZeMDMYlEkNd1cdIy5uNOQnPXfsklEcDTJinrDOAa9oeR9V69J66jhHL4=
X-Received: by 2002:a4a:d2c4:0:b0:57b:f285:ae41 with SMTP id
 j4-20020a4ad2c4000000b0057bf285ae41mr6125209oos.9.1696531593929; Thu, 05 Oct
 2023 11:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
 <ZR4N8cwzTMDanPUY@google.com>
In-Reply-To: <ZR4N8cwzTMDanPUY@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 5 Oct 2023 11:45:57 -0700
Message-ID: <CAF7b7moE19p+kDXuwaxHCY6=NXB95fNJ7ectNRxdUMMBpgT0Fg@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Oct 4, 2023 at 6:14=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> And peeking at future patches, pass in the RWX flags as bools, that way t=
his
> helper can deal with the bools=3D>flags conversion.  Oh, and fill the fla=
gs with
> bitwise ORs, that way future conflicts with private memory will be trivia=
l to
> resolve.
>
> E.g.
>
> static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>                                                  gpa_t gpa, gpa_t size,
>                                                  bool is_write, bool is_e=
xec)
> {
>         vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
>         vcpu->run->memory_fault.gpa =3D gpa;
>         vcpu->run->memory_fault.size =3D size;
>
>         vcpu->run->memory_fault.flags =3D 0;
>         if (is_write)
>                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLAG_=
WRITE;
>         else if (is_exec)
>                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLAG_=
EXEC;
>         else
>                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLAG_=
READ;
> }

Is a BUG/VM_BUG_ON() warranted in the (is_write && is_exec) case do
you think? I see that user_mem_abort already VM_BUG_ON()s for this
case, but if there's one in the x86 page fault path I don't
immediately see it. Also this helper could be called from other paths,
so maybe there's some value in it.

> I'll send you a clean-ish patch to use as a starting point sometime next =
week.

You mean something containing the next spin of the guest memfd stuff?
Or parts of David's series as well?
