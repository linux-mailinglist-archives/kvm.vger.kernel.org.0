Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CAF620166
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 22:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiKGVqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 16:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbiKGVqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 16:46:37 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB29727B3B;
        Mon,  7 Nov 2022 13:46:36 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso11555319pjc.5;
        Mon, 07 Nov 2022 13:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9On9UDwN9+FMOJXKCMZYipbKJoIjLKP2XZ3U7kBuoB0=;
        b=GL+2Bxv6ry2q2tVdZRODeD97j7WTZ0CqlPqVG3cOZfSQ2lPpNfGbSsDDWxIi7pHIp0
         4gPpC/0UyTeXngfMw/90jVGCYvfydu4VVDIBdRhsclgKtmxCEiA9BP4R87XQG30smBdC
         1/LRsqd/o2s4hFf8dQGeyUXxQVNajfdobkSuQnz0LYFbUg3nN2WjiofwzLBJS7P0QSlq
         3E2aD8E0qfRqk/z6hwmiW9lLNW6MmCIaXMhDFh5+LVoso6k/SENsDAmWDZa1hpQYz//Q
         JF3KaJnULb3SlFFzyr0MclyB75dQs6HtyFHyOI25a5zATM3F+OUwHUTUTEkKDNPpwCyo
         BpOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9On9UDwN9+FMOJXKCMZYipbKJoIjLKP2XZ3U7kBuoB0=;
        b=FJyU5gVhqx8C6BF91TQJtgUBwKjQYbDfq1f/A4hWR/E7Tr666sl+HDaXW/wivkt/Qv
         ufS3rSfx/z2Qv3mD5o+us1bnzBkn6V3aUfVeWdQvQdS2WALhTLiW0+jItDz3imq8s4sH
         FGqtjcrwtZGdTAPkYoOCit3Du090u43jnjNqRtp/vQqpUjNR69sejB/6+GD0j1cwg/nc
         h+UPQhfhgWdriQi3id9Fn/GVt1nZ5/0Ld50NReEei+RnARDXFNkkParyzb7TmXKkqabH
         AEZoOlZTCNpd49rxdxE0ZmD4k1H6g6kRSXdJnsCIttjJdb6XDbxmWGck61ZkhmsL15xb
         0gYQ==
X-Gm-Message-State: ACrzQf1SXzal/VpUH8GGuPWuhvHvtkU9C5gKlIh40U1BN4TYEsODTarA
        uGcW05z5ikqLH+Ud37fP/yE=
X-Google-Smtp-Source: AMsMyM5nI4bmuY9lD4XinO2gz+Xc6KHSLBRiOXpXoSFa21NNV37M1qdfO6ImmoOBa63VChvhPC/Cjg==
X-Received: by 2002:a17:90b:1d12:b0:20c:8edd:59a3 with SMTP id on18-20020a17090b1d1200b0020c8edd59a3mr52739175pjb.222.1667857596321;
        Mon, 07 Nov 2022 13:46:36 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id i126-20020a626d84000000b0056c0b98617esm4981650pfc.0.2022.11.07.13.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 13:46:35 -0800 (PST)
Date:   Mon, 7 Nov 2022 13:46:34 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Message-ID: <20221107214634.GE1063309@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221104071749.GC1063309@ls.amr.corp.intel.com>
 <Y2V1oslbw24/2Opd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2V1oslbw24/2Opd@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022 at 08:27:14PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Nov 04, 2022, Isaku Yamahata wrote:
> > Thanks for the patch series. I the rebased TDX KVM patch series and it worked.
> > Since cpu offline needs to be rejected in some cases(To keep at least one cpu
> > on a package), arch hook for cpu offline is needed.
> 
> I hate to bring this up because I doubt there's a real use case for SUSPEND with
> TDX, but the CPU offline path isn't just for true offlining of CPUs.  When the
> system enters SUSPEND, only the initiating CPU goes through kvm_suspend()+kvm_resume(),
> all responding CPUs go through CPU offline+online.  I.e. disallowing all CPUs from
> going "offline" will prevent suspending the system.

The current TDX KVM implementation disallows CPU package from offline only when
TDs are running.  If no TD is running, CPU offline is allowed.  So before
SUSPEND, TDs need to be killed via systemd or something.  After killing TDs, the
system can enter into SUSPEND state.


> I don't see anything in the TDX series or the specs that suggests suspend+resume
> is disallowed when TDX is enabled, so blocking that seems just as wrong as
> preventing software from soft-offlining CPUs.

When it comes to SUSPEND, it means suspend-to-idle, ACPI S1, S3, or S4.
suspend-to-idle doesn't require CPU offline.

Although CPU related spec doesn't mention about S3, the ACPI spec says

  7.4.2.2 System _S1 State (Sleeping with Processor Context Maintained)
  The processor-complex context is maintained.

  7.4.2.4 System _S3 State or 7.4.2.5 System _S4 State
  The processor-complex context is not maintained.

It's safe to say the processor context related to TDX is complex, I think.
Let me summarize the situation. What do you think?

- While no TD running:
  No additional limitation on CPU offline.

- On TD creation:
  If any of whole cpu package is software offlined, TD creation fails.
  Alternative: forcibly online necessary CPUs, create TD, and offline CPUs

- TD running:
  Although it's not required to keep all CPU packages online, keep CPU package
  from offlining for TD destruction.

- TD destruction:
  If any of whole cpu package is software offlined, TD destruction fails.
  The current implementation prevents any cpu package from offlinining during
  TD running.
  Alternative:
  - forcibly online necessary CPUs, destruct TD, and offline CPUs again and
    allow CPU package to offline
  - Stash TDX resources somewhere. When cpu packages are onlined, free those
    release.

- On SUSPEND:
  TODO: Allow CPU offline if S1 is requested.
  - suspend-to-idle: nothing to do because cpu offline isn't required
  - ACPI S1: Need to allow offline CPUs.  This can be implemented by referencing
    suspend_state_t pm_suspend_target_state is PM_SUSPEND_TO_STANBY.
  - ACPI S3/S4: refuse cpu offline.  The system needs to kill all TDs before
    starting SUSPEND process. This is what is implemented.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
