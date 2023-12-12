Return-Path: <kvm+bounces-4180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A34DC80EDCB
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 14:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EB8928181D
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 13:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEEDC61FDE;
	Tue, 12 Dec 2023 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnnrM/oj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D08AF
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 05:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702388297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4IjtSLSS+KMn2n0R4fQtLvtCI4SQNSXOvC4z09ahOFQ=;
	b=QnnrM/ojkQbotVaRI7gB8Obp3cWqBXS+M/DLubLAxsMccXdsu3QAhaD/eJ0nMfSSahs7VV
	V5nmMfxOEitoseQviDMqaPZpq8vF6y8l6UuDOEOxCTXZ4JM3sEezusI+CPhIhgeIBtMPqx
	k2xgasMcfK8U8LPUrh94/JMpPFOk4Uo=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-49OGMRMNNWedsTx7ckK_rw-1; Tue, 12 Dec 2023 08:38:16 -0500
X-MC-Unique: 49OGMRMNNWedsTx7ckK_rw-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7cb2d8b214dso112081241.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 05:38:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702388295; x=1702993095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4IjtSLSS+KMn2n0R4fQtLvtCI4SQNSXOvC4z09ahOFQ=;
        b=AfMrgyad1M/m6hC22mjui0h64x/s8WAfzoamcVxn5/eC/MQLFR71qlCnPkUDJisoOJ
         WYdI05Dst9kKyQQm3S0pAXymUjuapZ+c1Yj6vzkcsHnGCGXB1FhfalPFsAexCKxR+pid
         7lu3dHJ+iOyjNcZow3JJmUT+1a2hfxdnfo6r0i2gvFnsaK0/q8Rc/8uBSHfE6alnwavr
         4Z9Dm30gu2TSf2GSubmpfod8B5yibSsjVxS4bBrt6emexGNcaCATdZc9o2IZn0PueJlf
         J19sh2EqOG4pP3FC3BoLoufTWnfsJysfjHtqs9cqf/JSQBar2W7YYxE+iEZjy7n50sfu
         Ywvw==
X-Gm-Message-State: AOJu0Yx53itMIu1+uH/664JuxCjlcmkFv0JEvWoPf3ji+kYF3oIhnWMH
	0uaawg6km3XDDlWmjfAowXaZUZ9+BwQPAnSRPTwJKqOcV7zMCdWhT1MoLyFYRvHOzyr1I//cGrP
	T+wICmU8NKCbpFMbXWh/oxAn5kvax
X-Received: by 2002:a05:6102:954:b0:464:a4b9:5ca2 with SMTP id a20-20020a056102095400b00464a4b95ca2mr4133780vsi.43.1702388295582;
        Tue, 12 Dec 2023 05:38:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoi0rzc6o7Gt4+TFEGhMVoc3vZ6tzwUFixtpjFgOfHf47vt6vk5agyXIEXqqQZSIqeGr8AylCCZagp/mgF4KI=
X-Received: by 2002:a05:6102:954:b0:464:a4b9:5ca2 with SMTP id
 a20-20020a056102095400b00464a4b95ca2mr4133761vsi.43.1702388295319; Tue, 12
 Dec 2023 05:38:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230512233127.804012-1-seanjc@google.com> <20230512233127.804012-2-seanjc@google.com>
 <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
 <871qbud5f9.fsf@email.froward.int.ebiederm.org> <a02b40d3d9ae5b3037b9a9d5921cfb0144ab5610.camel@amazon.com>
 <7e30cfc2359dfef39d038e3734f7e5e3d9e82d68.camel@amazon.com>
 <87wmtk9u46.fsf@email.froward.int.ebiederm.org> <cf9e15bf3da411ada1c5b2bbdbfdea836029a5e1.camel@amazon.com>
In-Reply-To: <cf9e15bf3da411ada1c5b2bbdbfdea836029a5e1.camel@amazon.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 12 Dec 2023 14:38:02 +0100
Message-ID: <CABgObfZKOkUn3++g-YMkv7bsmKU77Y88NPBqt-5XoRJFLXDEFA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to
 hook restart/shutdown
To: "Gowans, James" <jgowans@amazon.com>
Cc: "Graf (AWS), Alexander" <graf@amazon.de>, "seanjc@google.com" <seanjc@google.com>, 
	"ebiederm@xmission.com" <ebiederm@xmission.com>, =?UTF-8?B?U2Now7ZuaGVyciwgSmFuIEgu?= <jschoenh@amazon.de>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, "james.morse@arm.com" <james.morse@arm.com>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "atishp@atishpatra.org" <atishp@atishpatra.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>, 
	"anup@brainfault.org" <anup@brainfault.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023 at 9:51=E2=80=AFAM Gowans, James <jgowans@amazon.com> =
wrote:
> 1. Does hardware_disable_nolock actually need to be done on *every* CPU
> or would the offlined ones be fine to ignore because they will be reset
> and the VMXE bit will be cleared that way? With cooperative CPU handover
> we probably do indeed want to do this on every CPU and not depend on
> resetting.

Offlined and onlined CPUs are handled via the CPU hotplug state machine,
which calls into kvm_online_cpu and kvm_offline_cpu.

Paolo


