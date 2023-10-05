Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998E17B99C4
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbjJEBol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjJEBok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:44:40 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42852C1
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:44:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a4f656f751so7294747b3.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696470270; x=1697075070; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=brblM1cgPenAQfqP7iVYjJGMX2iIkPxCWUe6XyphfiA=;
        b=unmTgSGRQd5WUElWeEy/LJKed4c+nZRtfnW3sZP/mMdblW0n8WUMg1Tea+DGCIbwok
         ZD2MEjqOgO7bgTdBkg7k8fABT76MKzq3kYk513NpZs+s+EUZJzEVZv2jLkwXEhYh2GNM
         yXIvZenI2RgXVQjq5FoUl76LD+GatQkVZosSugVrCEb509AmTUZPVl0Fcgjwcp14ciJW
         TCo8Kl+JI55FWQEA/PEBLN+cyARIvj4XGz2m93rd6SAI3ezhj0e0skxjoQSjpwQDPDZ0
         yISJbT2EXz7h7/uyzcM0LitcWnKSCzQzvw6nWwhvlStJ/4naQ//sO00fuAmxn1qGckKW
         i4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696470270; x=1697075070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=brblM1cgPenAQfqP7iVYjJGMX2iIkPxCWUe6XyphfiA=;
        b=AT8EopBIIafdHfYlyF+/WcnIUh75naXbEvNLxuq5WIAxI90TeJVoUXxrZ3XZeN/D1/
         +L/3xD8bVTaXsxiytkmuMCMztKeBMcz6bsBOtIoEts/MolarHS1A+1Zoo7mLlL9nggHk
         vD0CoYNg5fSJnYq6n2y0zYMEBk6gyyL1QOFnkXRJ9z80QmR8u9ldmEpPIDBsYFgJAjUq
         Zz/LgfWgTeob8NQisZMsEgchRCe+RDGFjRQFSQJ8ibqp3ZHanXxGo33u+Jvjd40yqUd7
         ipPflPeX9MmafozrKOnHO05mBq4TQaamH56sZ8idfobWuvOn8fvyAelTiavfL1SMqL98
         IIgw==
X-Gm-Message-State: AOJu0YyIovptvBGWQ7pwt4w6JoNqxuTMwTzykjEbM8t8lhKst0wyaVFC
        4urgoMvh1nRqmvAMKACKDrOa8me0ybU=
X-Google-Smtp-Source: AGHT+IFS+qnZ1QlDJ/CSV8U3hLt+JuAx5JZDqupY2JuMBGE0zT3Mhw/S/rlbAo3YBzz7Lh9UPHdd4OtkY7c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:741:0:b0:d81:bb31:d2fa with SMTP id
 s1-20020a5b0741000000b00d81bb31d2famr61515ybq.3.1696470270584; Wed, 04 Oct
 2023 18:44:30 -0700 (PDT)
Date:   Wed, 4 Oct 2023 18:44:29 -0700
In-Reply-To: <20230908222905.1321305-11-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
Message-ID: <ZR4U_czGstnDrVxo@google.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eh, the shortlog basically says "do work" with a lot of fancy words.  It really
just boils down to:

  KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MISSING

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> Change the "atomic" parameter of __gfn_to_pfn_memslot() to an enum which

I've pushed back on more booleans multiple times, but IMO this is even worse.
E.g. what does an "upgrade" to atomic even mean?

Since we have line of sight to getting out of boolean hell via David's series,
just bite the bullet for now.  Deciphering the callers will suck, but not really
anymore than it already sucks.

kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
			       bool atomic, bool interruptible, bool *async,
			       bool write_fault, bool *writable,
			       bool can_do_userfault, hva_t *hva)
{
	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);

	if (hva)
		*hva = addr;

	if (kvm_is_error_hva(addr)) {
		if (writable)
			*writable = false;

		if (addr == KVM_HVA_ERR_RO_BAD)
			return KVM_PFN_ERR_RO_FAULT;

		return KVM_PFN_NOSLOT;
	}

	if (!atomic && can_do_userfault &&
	    kvm_is_slot_userfault_on_missing(slot)) {
		atomic = true;
		if (async) {
			*async = false;
			async = NULL;
		}
	}

	/* Do not map writable pfn in the readonly memslot. */
	if (writable && memslot_is_readonly(slot)) {
		*writable = false;
		writable = NULL;
	}

	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
			  writable);
}
