Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC84D597AAA
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 02:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242421AbiHRAdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 20:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239719AbiHRAdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 20:33:47 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7041B5FF73
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 17:33:44 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q16so51205pgq.6
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 17:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=TFEXJfTyipzkT8/ebHWDfQXhb3yjAGVWd7mOzrHjITo=;
        b=iHwOTfQtO3DUJwRJqStuo8FlhfCsSkEU0LTJahxAERPkVCR3HT2L4BApsMZNKIL2iW
         CuaacBL3pfm8rZezAjkEYw4fcs65rn00evZ5Lh0iC/jNlGWlOOf5AxpZrCkmjmUGEPPq
         EU3COGBgtxMkF6lD44QMqgX84BWBX6+Aor9aMQiQzx50h1xqlnUKUJSqBKK+R7UPLkHb
         bxhPzHT9cKq4csUbRVjMuHoD7jL1OQ2e/0zq0kxDHAWf3oqou5V1h2magQFxydWl5Tfo
         mz3Gvf5GnqbE3B3FhF+KbZh2WQjkOrfX4hh3XQknkb8oWOjORZAQNNCrLUn7Y3G53H/T
         bIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=TFEXJfTyipzkT8/ebHWDfQXhb3yjAGVWd7mOzrHjITo=;
        b=HAatAEgbOfnaO1FGHJA/Mp+GsSvbY+/9vM7xmxlAi386kwY1XTKOitDflV/ijexmDa
         T4I7K4EsK+viNdZOf7BimBjzaYgVAbMXPeeG+7RiT4d5IMfU/hog12NwUpiVKxgXX/gz
         sH1otphQPhsnLW2CKxfTVXS03X2rPZgxbpgKyQkUi9/ZTBrWr6pmAu8jqRFp6DDSStJv
         v6A/KeiiiSB4Kx4wySaXyLKbDIcfC3NbBgc7Og+ujcHeEvWpsex6Hp+JPbABpQlKiBD4
         QFDFXUH9YEIg5zDPmsd5ANzcmpFZmhPRjyhN7PJLyYHfqDS5+nSv7Jo84OopENvxPtbo
         JC7w==
X-Gm-Message-State: ACgBeo0MKJLJHk182dRwUSSh04v7qa3HtYOVCIiaL00goc3VDSH+bAzf
        kWm/CQXJuKgKkJZ+tjqubDnxYQ==
X-Google-Smtp-Source: AA6agR4VQ8JzuFluuSuq0biVYR2+bR5ZtatpuzKvGjC9V1MKjdcjtMHCpaTh10IrftrZsfZvMS7VsA==
X-Received: by 2002:a63:485a:0:b0:41d:ed37:d937 with SMTP id x26-20020a63485a000000b0041ded37d937mr601467pgk.336.1660782823804;
        Wed, 17 Aug 2022 17:33:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7998e000000b005326acf9fecsm140819pfh.2.2022.08.17.17.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 17:33:43 -0700 (PDT)
Date:   Thu, 18 Aug 2022 00:33:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com
Subject: Re: [V3 08/11] KVM: selftests: add library for creating/interacting
 with SEV guests
Message-ID: <Yv2I48GqFpc9PHIy@google.com>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-9-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810152033.946942-9-pgonda@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022, Peter Gonda wrote:
> +enum {
> +       SEV_GSTATE_UNINIT = 0,
> +       SEV_GSTATE_LUPDATE,
> +       SEV_GSTATE_LSECRET,
> +       SEV_GSTATE_RUNNING,
> +};
> +

Name the enum, e.g. enum sev_guest_state?

And s/GSTATE/GUEST?  Ugh, AMD's documentation uses GSTATE.

But looking at the docs, I only see GSTATE_LAUNCH?  Or does SEV have different
status codes than -ES and/or -SNP?

> +struct kvm_vm *sev_get_vm(struct sev_vm *sev)
> +{
> +	return sev->vm;

Why bother with a wrapper?

> +}
> +
> +uint8_t sev_get_enc_bit(struct sev_vm *sev)
> +{

Same here, IMO it just obfuscates code with no real benefit.  ANd it's inconsistent,
e.g. why have a wrapper for enc_bit but not sev->fd?

> +	return sev->enc_bit;
> +}
> +
> +void sev_ioctl(int sev_fd, int cmd, void *data)
> +{
> +	int ret;
> +	struct sev_issue_cmd arg;
> +
> +	arg.cmd = cmd;
> +	arg.data = (unsigned long)data;
> +	ret = ioctl(sev_fd, SEV_ISSUE_CMD, &arg);
> +	TEST_ASSERT(ret == 0,
> +		    "SEV ioctl %d failed, error: %d, fw_error: %d",
> +		    cmd, ret, arg.error);
> +}
> +
> +void kvm_sev_ioctl(struct sev_vm *sev, int cmd, void *data)
> +{
> +	struct kvm_sev_cmd arg = {0};
> +	int ret;
> +
> +	arg.id = cmd;
> +	arg.sev_fd = sev->fd;
> +	arg.data = (__u64)data;
> +
> +	ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_OP, &arg);
> +	TEST_ASSERT(ret == 0,
> +		    "SEV KVM ioctl %d failed, rc: %i errno: %i (%s), fw_error: %d",
> +		    cmd, ret, errno, strerror(errno), arg.error);
> +}
> +
> +/* Local helpers. */
> +
> +static void

Don't split here, e.g. a grep/search for the function, should also show the return
type and any attributes, e.g. "static" vs. something else is typically much more
interesting than the parameters (and parameters is not a fully solvable problem).

> +sev_register_user_region(struct sev_vm *sev, void *hva, uint64_t size)

Align like so:

static void sev_register_user_region(struct sev_vm *sev, void *hva,
				     uint64_t size)

or maybe even let it poke out.

> +{
> +	struct kvm_enc_region range = {0};
> +	int ret;
> +
> +	pr_debug("%s: hva: %p, size: %lu\n", __func__, hva, size);
> +
> +	range.addr = (__u64)hva;
> +	range.size = size;
> +
> +	ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
> +	TEST_ASSERT(ret == 0, "failed to register user range, errno: %i\n", errno);
> +}
> +
> +static void
> +sev_encrypt_phy_range(struct sev_vm *sev, vm_paddr_t gpa, uint64_t size)

Same thing here.

> +{
> +	struct kvm_sev_launch_update_data ksev_update_data = {0};
> +
> +	pr_debug("%s: addr: 0x%lx, size: %lu\n", __func__, gpa, size);
> +
> +	ksev_update_data.uaddr = (__u64)addr_gpa2hva(sev->vm, gpa);
> +	ksev_update_data.len = size;
> +
> +	kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_UPDATE_DATA, &ksev_update_data);
> +}
> +
> +static void sev_encrypt(struct sev_vm *sev)
> +{
> +	const struct sparsebit *enc_phy_pages;
> +	struct kvm_vm *vm = sev->vm;
> +	sparsebit_idx_t pg = 0;
> +	vm_paddr_t gpa_start;
> +	uint64_t memory_size;
> +
> +	/* Only memslot 0 supported for now. */

Eww.  Haven't looked at this in depth, but is there a way to avoid hardcoding the
memslot in this code?

> +void sev_vm_launch(struct sev_vm *sev)
> +{
> +	struct kvm_sev_launch_start ksev_launch_start = {0};
> +	struct kvm_sev_guest_status ksev_status = {0};

Doesn't " = {};" do the same thing?  And for the status, and any other cases where
userspace is reading, wouldn't it be better from a test coverage perspective to
_not_ zero the data?  Hmm, though I suppose false passes are possible in that case...

> +	/* Need to use ucall_shared for synchronization. */
> +	//ucall_init_ops(sev_get_vm(sev), NULL, &ucall_ops_halt);

Can this be deleted?  If not, what's up?
