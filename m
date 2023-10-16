Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51377CAD8C
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjJPPbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbjJPPbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:31:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9D6EA
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697470219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CRf3fYGKsTrlOhUDvR5Nm0aYucqIml+Eu+5HAJHgZQY=;
        b=H73VZ51BccaGQ/qRLpXcXLhcJiXy2EW70Nw9b23PRaAjXSnBOOj9aIe9CVtMHCcV5AECeF
        /c4NrYpv6Y3rRzMLat9/9EUTsKLQ7I/+qKzZY9gvQvqhnGeJlba/+8dYaeKTtmjOsvCtEK
        Xjfx+b0u1wsKeaxsDULgHwIHgi8YaLE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-5rnxzrkYOMSSC8X6SHVcYg-1; Mon, 16 Oct 2023 11:30:16 -0400
X-MC-Unique: 5rnxzrkYOMSSC8X6SHVcYg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A50881B15E;
        Mon, 16 Oct 2023 15:30:15 +0000 (UTC)
Received: from localhost (unknown [10.39.195.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7448B492BFA;
        Mon, 16 Oct 2023 15:30:12 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
In-Reply-To: <20231011195740.3349631-6-oliver.upton@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 16 Oct 2023 17:30:06 +0200
Message-ID: <87fs2aegap.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> From: Jing Zhang <jingzhangos@google.com>
>
> Add tests to verify setting ID registers from userspace is handled
> correctly by KVM. Also add a test case to use ioctl
> KVM_ARM_GET_REG_WRITABLE_MASKS to get writable masks.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/set_id_regs.c       | 479 ++++++++++++++++++
>  2 files changed, 480 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c

(...)

> +static void test_user_set_reg(struct kvm_vcpu *vcpu, bool aarch64_only)
> +{
> +	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
> +	struct reg_mask_range range = {
> +		.addr = (__u64)masks,
> +	};
> +	int ret;
> +
> +	/* KVM should return error when reserved field is not zero */
> +	range.reserved[0] = 1;
> +	ret = __vm_ioctl(vcpu->vm, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
> +	TEST_ASSERT(ret, "KVM doesn't check invalid parameters.");

I think the code should first check for
KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES -- newer kselftests are supposed
to be able to run on older kernels, and we should just skip all of this
if the API isn't there.

> +
> +	/* Get writable masks for feature ID registers */
> +	memset(range.reserved, 0, sizeof(range.reserved));
> +	vm_ioctl(vcpu->vm, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);

