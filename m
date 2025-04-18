Return-Path: <kvm+bounces-43664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 238FEA93814
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 15:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79B9F7B0DD9
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 13:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3522F509;
	Fri, 18 Apr 2025 13:46:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E8629A0
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744983995; cv=none; b=BZ0az1qxl+x0rQrOwyy01whQ7WyiYy+oTOPBnxsYaNYobbuh6B4TmjSVI1nWxd0FJeteRp6DSxbtNXok6XgHZZBOMHC8/FH7g/kh2pDC1EmA1O/e/xIfrEQ2sEq6WAuIDIkiS6KJDaOc8a08vxptVKxkyz8CWwUTqmzrN9lxYbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744983995; c=relaxed/simple;
	bh=7AQprvY/HRWcHYGjFHp6XpOtPzUcLRDdnw69WqqOpPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKi8oiYQpSGB9WWIcPxLvDlZOD/HQGjByJfONtKtMO1rtgznMgnspQ1jPVx+kixzny0oaTyWgDM1Y/HjL6251UeKOtDf+mAoU95TrYP7dsNxo59IQCDQ3i+rAnCesun7hUI0ulY7yseOIUfZLq1sLAZry0e7S0aSEsTX6aFlBWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-03 (Coremail) with SMTP id rQCowAAXvTmvVwJoS0TdCQ--.59810S2;
	Fri, 18 Apr 2025 21:46:25 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: pbonzini@redhat.com
Cc: chenyufeng@iie.ac.cn,
	kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: potential NULL pointer dereference in kvm_vm_ioctl_create_vcpu()
Date: Fri, 18 Apr 2025 21:46:14 +0800
Message-ID: <20250418134614.626-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <596ce9b2-aa00-4bc5-ae20-451f3176d904@redhat.com>
References: <596ce9b2-aa00-4bc5-ae20-451f3176d904@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:rQCowAAXvTmvVwJoS0TdCQ--.59810S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WryxWFW7KF4UKr1xCFW3KFg_yoW8Xw4kpF
	sxKw10qws8Jw4jy3y2yws8ZryUtanIga4kCFyDJa1rAF42yF95GFy8Kr909F17CrW0qa9a
	yr98Xa47u3W5Cw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkI14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW5GwCF
	04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
	18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vI
	r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
	1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
	x4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUjdMaUUUUUU==
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiBgsQEmgCIt2ThAAAsN

> On 4/18/25 06:24, Chen Yufeng wrote:=0D
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
> > =0D
> > Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>=0D
> > ---=0D
> >   virt/kvm/kvm_main.c | 2 ++=0D
> >   1 file changed, 2 insertions(+)=0D
> > =0D
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c=0D
> > index e85b33a92624..3c97e598d866 100644=0D
> > --- a/virt/kvm/kvm_main.c=0D
> > +++ b/virt/kvm/kvm_main.c=0D
> > @@ -4178,7 +4178,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *k=
vm, unsigned long id)=0D
> >   	xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);=0D
> >   unlock_vcpu_destroy:=0D
> >   	mutex_unlock(&kvm->lock);=0D
> > +	kvm_arch_vcpu_destroy(vcpu);=0D
> >   	kvm_dirty_ring_free(&vcpu->dirty_ring);=0D
> > +	goto vcpu_free_run_page;=0D
> =0D
> Makes sense, but the goto is not needed.  Just move =0D
> kvm_dirty_ring_free() above "vcpu_free_run_page:", in the same style as =
=0D
> kvm_vcpu_destroy().=0D
> =0D
> Paolo=0D
=0D
You're right, and I'll take your advice and send v2 patch.=0D
=0D
> >   arch_vcpu_destroy:=0D
> >   	kvm_arch_vcpu_destroy(vcpu);=0D
> >   vcpu_free_run_page:=0D
=0D
--=0D
Thanks, =0D
=0D
Chen Yufeng=


