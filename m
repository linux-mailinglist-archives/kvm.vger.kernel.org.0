Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D904E72693E
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbjFGSyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjFGSx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:53:59 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC841BD6;
        Wed,  7 Jun 2023 11:53:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-653436fcc1bso3376312b3a.2;
        Wed, 07 Jun 2023 11:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686164037; x=1688756037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CWlI8O5y17mVIgSckRO28rpjnfk78X92V4g11ktEnnQ=;
        b=LrSIqPYIl2O2Vb7lnDHMQaAJbXiVOZhw8EnOdrmM+4Yq6NcCwopRy54dAnHyLKik1N
         vKHSVT487M6ibmwfs5fmti5ThA0U6IlWp+XMlljGp2Vb52tp+h9/TXHDcYlDQEaZkLvC
         QHMRKHS5z+P+e94aRD5q5oIuMQ1z/q5JSyiD7IfN0G+7JpjsVFs/che2oi9MKW8suAEf
         R7cmM15MdF3Ep3Z98w2ypVreOu9VaGXAgrhRtIGSTwN0tswPxKMd0ZUdhfSO5OJ6ldeO
         6fS/KBCqzZA6oDXAPw8KwQw1raW/6FMFjNZ6whQZo7dmu9uXUuJOpQLAE1iHj6Y2tZJy
         32PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686164037; x=1688756037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWlI8O5y17mVIgSckRO28rpjnfk78X92V4g11ktEnnQ=;
        b=U3368yENAOx8LMqtOQLfeQzSmjHWSnpfgYoghpgAO4XZFiRz4NoyQ7hCgl+5UZf2R2
         Zvt+kK+efImvWSb40gmI1KYAk1HAZC268ID6Z6Kg0huDHxEp7g8NOAuCRmrLy+DjeX3N
         /R4QsJnb55PXWnQu0lZd6vk0hKO78U01cLNAlrod7tYWV+TMCt++QkJIikfYsejmYPkj
         5nHNXb3hSifcWNfZBri5+3LjKdyBDNHR36HHrAp1S/pt4mU3swgKkOcg8iUoeyqW7hH5
         B4WmhNu4Sixqp+/ijSWDt/w4HTWA5T3ufxkHOdB9yRxm0/xgiMORt9ONXnjXrusAO2no
         pSgw==
X-Gm-Message-State: AC+VfDxGsGm0I61vwdfzW327SpCitfleObbUKlJ36CoPGahVvlZrkNtr
        4OK3w0ZqNBHbMMvzJfAKUYvXH9bEkUFWEA==
X-Google-Smtp-Source: ACHHUZ74yVXNTUyi/V0LeKw31FQ74c28oWW2Gy0sH1FOyjyS4+1dENhhE4ZRoViIU8ul9JyRxCWSBA==
X-Received: by 2002:a05:6a00:1252:b0:660:523a:8fef with SMTP id u18-20020a056a00125200b00660523a8fefmr2920833pfi.13.1686164037156;
        Wed, 07 Jun 2023 11:53:57 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id n35-20020a635923000000b0051303d3e3c5sm9372544pgb.42.2023.06.07.11.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:53:56 -0700 (PDT)
Date:   Wed, 7 Jun 2023 11:53:55 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <20230607185355.GH2244082@ls.amr.corp.intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023 at 07:24:23AM -0700,
Dave Hansen <dave.hansen@intel.com> wrote:

> On 6/4/23 07:27, Kai Huang wrote:
> > TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).  This
> > mode runs only the TDX module itself or other code to load the TDX
> > module.
> > 
> > The host kernel communicates with SEAM software via a new SEAMCALL
> > instruction.  This is conceptually similar to a guest->host hypercall,
> > except it is made from the host to SEAM software instead.  The TDX
> > module establishes a new SEAMCALL ABI which allows the host to
> > initialize the module and to manage VMs.
> > 
> > Add infrastructure to make SEAMCALLs.  The SEAMCALL ABI is very similar
> > to the TDCALL ABI and leverages much TDCALL infrastructure.
> > 
> > SEAMCALL instruction causes #GP when TDX isn't BIOS enabled, and #UD
> > when CPU is not in VMX operation.  Currently, only KVM code mocks with
> 
> "mocks"?  Did you mean "mucks"?
> 
> > VMX enabling, and KVM is the only user of TDX.  This implementation
> > chooses to make KVM itself responsible for enabling VMX before using
> > TDX and let the rest of the kernel stay blissfully unaware of VMX.
> > 
> > The current TDX_MODULE_CALL macro handles neither #GP nor #UD.  The
> > kernel would hit Oops if SEAMCALL were mistakenly made w/o enabling VMX
> > first.  Architecturally, there is no CPU flag to check whether the CPU
> > is in VMX operation.  Also, if a BIOS were buggy, it could still report
> > valid TDX private KeyIDs when TDX actually couldn't be enabled.
> 
> I'm not sure this is a great justification.  If the BIOS is lying to the
> OS, we _should_ oops.
> 
> How else can this happen other than silly kernel bugs.  It's OK to oops
> in the face of silly kernel bugs.

TDX KVM + reboot can hit #UD.  On reboot, VMX is disabled (VMXOFF) via
syscore.shutdown callback.  However, guest TD can be still running to issue
SEAMCALL resulting in #UD.

Or we can postpone the change and make the TDX KVM patch series carry a patch
for it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
