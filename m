Return-Path: <kvm+bounces-43691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65AF9A9422C
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 09:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D2AD4413E0
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 07:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9C2198E76;
	Sat, 19 Apr 2025 07:48:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808E013C695
	for <kvm@vger.kernel.org>; Sat, 19 Apr 2025 07:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745048900; cv=none; b=DO3y7spk6R3BN8aIcCUcS6fhY3QWPk/iaKJKgTpXsHQdbFs12xFAR0BvtBrqrW++WKpbv1BASY5oPgC47uzxZ0Mvhe+MXtm7UmHUhHbP552JBeNM+1SMOafoKLeSyjEVTa3B/922gXPcz0hEJ4Wpb2sL4/NJxzJ5dg26PjtOvDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745048900; c=relaxed/simple;
	bh=XG5A0M+Cwfx6NdY3cmI/p5FoWgiCB96p/en3K6pYEuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4SwIKU2C4M+2ZJTsY+ccKoJZ1qYGAeYBFvyjtqL0VBCtUbM7V+nK+o3SqdEgbpyANKwqTWtGwLVlKPrClD+JAFrBmBF5u8EKR32TytKrHfFhltYoQ2PVuzRG6zN+Y0oFu/BYD+oP4bPTwMi/4DsmWIGeAM8D8Revseg/mG4VlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-03 (Coremail) with SMTP id rQCowABXBUI3VQNo3ZQhCg--.3182S2;
	Sat, 19 Apr 2025 15:48:10 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: pbonzini@redhat.com
Cc: chenyufeng@iie.ac.cn,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2] kvm: potential NULL pointer dereference in kvm_vm_ioctl_create_vcpu()
Date: Sat, 19 Apr 2025 15:47:57 +0800
Message-ID: <20250419074758.1097-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <dc5789b3-79fe-4589-ae40-00ad28a90807@redhat.com>
References: <dc5789b3-79fe-4589-ae40-00ad28a90807@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:rQCowABXBUI3VQNo3ZQhCg--.3182S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr17uw1xWF1kuF4UXrW8JFb_yoW8GF48pF
	4akw1Fqw4DJw4kZFZ7ArWkZryDKanxuaykJrn8Wwn8Z3y7AFnYkFZ2grZ5u347uFWxGa10
	vr1UJ3Wfu3Wak3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
	6r4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbrMaUUUUUU==
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiCRAQEmgCH2yqsAABsZ

> On 4/18/25 15:44, Chen Yufeng wrote:=0D
> > A patch similar to commit 5593473a1e6c ("KVM: avoid NULL pointer=0D
> >   dereference in kvm_dirty_ring_push").=0D
> > =0D
> > If kvm_get_vcpu_by_id() or xa_insert() failed, kvm_vm_ioctl_create_vcpu=
()=0D
> > will call kvm_dirty_ring_free(), freeing ring->dirty_gfns and setting i=
t=0D
> > to NULL. Then, it calls kvm_arch_vcpu_destroy(), which may call=0D
> > kvm_dirty_ring_push() in specific call stack under the same conditions =
as=0D
> > previous commit said. Finally, kvm_dirty_ring_push() will use=0D
> > ring->dirty_gfns, leading to a NULL pointer dereference.=0D
> =0D
> Actually I'm not convinced that this can happen; at least not in the =0D
> same way as commit 5593473a1e6c, because KVM_RUN can only be invoked =0D
> after the "point of no return" of create_vcpu_fd().=0D
> =0D
> The patch is good anyway because it's cleaner to use the same order as =0D
> in kvm_vcpu_destroy(), but perhaps you can also move =0D
> kvm_dirty_ring_alloc() before kvm_arch_vcpu_create(), so that the order =
=0D
> remains opposite for creation and destruction?=0D
=0D
As you pointed out, I'm also unsure whether this can actually be =0D
triggered.=0D
=0D
I agree that the fix following the approach of commit 5593473a1e6c will =0D
work. However, I wonder if swapping the order of kvm_dirty_ring_alloc() =0D
and kvm_arch_vcpu_create() might introduce other potential issues?=0D
=0D
> Thanks,=0D
> =0D
> Paolo=0D
=0D
--=0D
Thanks, =0D
=0D
Chen Yufeng=


