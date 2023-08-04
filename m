Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5768F76F67F
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 02:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbjHDAWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 20:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjHDAWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 20:22:09 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A293AB1
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 17:22:08 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583c1903ad3so16453887b3.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 17:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691108527; x=1691713327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5v9RLIelIMDoD5zJVzNP21pOJEl2y05Tafl1b5ngjGE=;
        b=Ru6oLzAIVGMq8yDcmCG+/o8/WNklCRDQI6WEIMl5TVDkbV6k8wZVAl0qIJOeT3DzRe
         oq9Gf8fXykFIp5sXQZK42fU1QWaqqt5rBk7lO9Jlbfejo/qEjLrLqXB+amHj2ElYvhJi
         8AzovMgMclHMKTgQd243kdehtgz6gIbKtY/HGfREmpMGVu0PxY4R5EO883EbGXlGvCtH
         tZlYmiNfNdikS6VwQXjytZb4mCz/yFXNyrnmnrC3HNG9ZgVlvpvnZ9xiQVxi+M+AFugS
         zV/H3Sua+tnp3DVrc1woKvG5ZkS6/5jhYF5ho5WxYc+1ejcr1GerhPT9CgV+0AN5Xzba
         OR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691108527; x=1691713327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5v9RLIelIMDoD5zJVzNP21pOJEl2y05Tafl1b5ngjGE=;
        b=Zk9UmOilhsMOnU1CLNTief7/Fwl8seRlzt/acxkF70m0BdXuZu9BeIJNUuX4kAn3w6
         zdResTesm52HsxnWDmR/6YxwM1BgPLEgQzS/xn3q7poEauGndXGUnpbSCfAU5tYg1GcP
         nxbgLkl4gJtIDQvBs5B6Agkm2rJ6ezWccx0ldsHznl3XwTvZ1wqVt0gDM4FFVI1atOZo
         RDFy4FU2UkEOb881EBHHh0Qo0STDz0/C8TS0PsOvmtYid5ymhFPz8TH57/3MG6+3DWxn
         /ZaHLtuzweihYDbYWZS9I5KPyZvtCzpWkW0XpYmAdW6oe3nhsgP9WtO8evFgrkH/z/Nr
         MaGg==
X-Gm-Message-State: AOJu0YzONWGInD0Z9Y3UdjeNEaERvEHOUJzwrY0dUg5u2zv9QFSNWRp8
        zPBPJzXB0OLZFZMFDxITNXK4I/iHHXo=
X-Google-Smtp-Source: AGHT+IHdu0RPBuXKwkIkUzJj3eHLXkomfy9BtqNXWpF9pgQM4FabT+hTnahDklWgffQDj44s5Yp2U28BWoY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae41:0:b0:583:abae:56ab with SMTP id
 g1-20020a81ae41000000b00583abae56abmr992ywk.7.1691108527435; Thu, 03 Aug 2023
 17:22:07 -0700 (PDT)
Date:   Thu, 3 Aug 2023 17:22:05 -0700
In-Reply-To: <20230418101306.98263-1-metikaya@amazon.co.uk>
Mime-Version: 1.0
References: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org> <20230418101306.98263-1-metikaya@amazon.co.uk>
Message-ID: <ZMxErVeAj2HPZcPc@google.com>
Subject: Re: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
From:   Sean Christopherson <seanjc@google.com>
To:     Metin Kaya <metikaya@amazon.co.uk>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, x86@kernel.org,
        bp@alien8.de, dwmw@amazon.co.uk, paul@xen.org, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023, Metin Kaya wrote:
> Implement in-KVM support for Xen's HVMOP_flush_tlbs hypercall, which
> allows the guest to flush all vCPU's TLBs. KVM doesn't provide an
> ioctl() to precisely flush guest TLBs, and punting to userspace would
> likely negate the performance benefits of avoiding a TLB shootdown in
> the guest.
> 
> Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
> 
> ---
> v3:
>   - Addressed comments for v2.
>   - Verified with XTF/invlpg test case.
> 
> v2:
>   - Removed an irrelevant URL from commit message.
> ---

I had applied this and even generated the "thank you", but then I actually ran
the KUT access test[*].  It may very well be a pre-existing bug, but that doesn't
change the fact that this patch breaks a test.

I apologize for being snippy, especially if it turns out this is unique to HSW
(or worse, my system), and your systems don't exhibit issues.  Getting the test
to run took way too long and I'm bit grumpy.

Anyways, whatever is going wrong needs to be sorted out before this can be applied.

[*] https://lore.kernel.org/all/ZMxDRg6gWsVLeYFL@google.com
