Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD2268E754
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 06:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjBHFJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 00:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjBHFJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 00:09:42 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0053842DD6;
        Tue,  7 Feb 2023 21:09:38 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id q13so1248556qtx.2;
        Tue, 07 Feb 2023 21:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wO7tEZofTjlP43exJot2Y++Vw18gZ4gFovpf48PsQGc=;
        b=n0rBCYJwLAViHC0vKZG1IWX/zXQN//VStmp/Ze5evE6U/wLfbVERCRFw/PGa5oYY0s
         Dw4ygJUzzhjNZjK+DylXSI9qD94ITbOMtqAaaRLWRGHLtinkU9ZNludb0soYt2gcIO3W
         54tBCjGe0fTho99uur5+eN3F4VVV/9uaWfWLhuYU/RlsYjIaScexO32P5IoxBUFZmEQS
         q/4FlyUve+sfy9R8v9x+zEJ+FfeqzbUKW3+ctWxO8fU2L5f7AMPvHOeB4EZKEqrTm1lC
         +f+nUp3mx9R8WLLlmGTaUZLqqYazrFGgHkxMRf+Nv3F8spjE4zhc0FiLoDcTfSeDJlsY
         MLew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wO7tEZofTjlP43exJot2Y++Vw18gZ4gFovpf48PsQGc=;
        b=Gdv1DZacpCA912J8xrUIY95HWk0RkwPpZpyb4caYkcQaVJtLUFa215Qv56293C5mwE
         Aks8I3rGzoeOVRtYK1WtK3FspQu4RiEVxdmQNs0hfDSqDvYZTQKQXWMXKWmbv4Fz2F8Z
         eFo+sa1r4pZ9rgvJcxxkR7/kbIMeq9o8+3CcZVr67TiESHeEzmn8ffgAhsvgyeOCtCiD
         xvFAX3lND6fjAg2+h/H6k0GevYNZ3tJF3QayjVIz48JPgSxM/Nu2sC9LG5wKoEMczvZU
         l+XKlGWHC6tlzkARm5qSRzPkz/9d1+KEecF6zXZUP52btOzY5ST25M0p3I5IzHZIFNWa
         eLPQ==
X-Gm-Message-State: AO0yUKVvifLEyKam+amERFsExnexbUsmtzaItEnxz8mb61aBfM1yHXba
        TDFv1AhQ1J43GWHB/rbm1wsPgbfWQQoivDHDRQ==
X-Google-Smtp-Source: AK7set8rGj9BgfiWua/E8g1e53NYzhyhzDDRkJGMBLvVV7nsupdngWNOwx6yKZSnXUq1THVSEZMsowW8/gXcOz7QEp4=
X-Received: by 2002:ac8:7f4b:0:b0:3ba:2794:e468 with SMTP id
 g11-20020ac87f4b000000b003ba2794e468mr900989qtk.412.1675832976846; Tue, 07
 Feb 2023 21:09:36 -0800 (PST)
MIME-Version: 1.0
References: <20230207230436.2690891-1-usama.arif@bytedance.com> <20230207230436.2690891-7-usama.arif@bytedance.com>
In-Reply-To: <20230207230436.2690891-7-usama.arif@bytedance.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Wed, 8 Feb 2023 00:09:25 -0500
Message-ID: <CAMzpN2iejCnBeBdC6+92fUL2k8ZdAq_jEgXX+RSoGMhRZ0UBSA@mail.gmail.com>
Subject: Re: [PATCH v7 6/9] x86/smpboot: Support parallel startup of secondary CPUs
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 7, 2023 at 6:10 PM Usama Arif <usama.arif@bytedance.com> wrote:
>
> From: Thomas Gleixner <tglx@linutronix.de>
>
> Rework the real-mode startup code to allow for APs to be brought up in
> parallel. This is in two parts:
>
> 1. Introduce a bit-spinlock to prevent them from all using the real
>    mode stack at the same time.
>
> 2. Avoid the use of global variables for passing per-CPU information to
>    the APs.
>
> To achieve the latter, export the cpuid_to_apicid[] array so that each
> AP can find its own per_cpu data (and thus initial_gs, initial_stack and
> early_gdt_descr) by searching therein based on its APIC ID.
>
> Introduce a global variable 'smpboot_control' indicating to the AP how
> it should find its APIC ID. For a serialized bringup, the APIC ID is
> explicitly passed in the low bits of smpboot_control, while for parallel
> mode there are flags directing the AP to find its APIC ID in CPUID leaf
> 0x0b (for X2APIC mode) or CPUID leaf 0x01 where 8 bits are sufficient.

For the serialized bringup case, it would be simpler to just put the
cpu number in the lower bits instead of the APIC id, skipping the
lookup.

--
Brian Gerst
