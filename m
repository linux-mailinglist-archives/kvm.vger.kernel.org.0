Return-Path: <kvm+bounces-7427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71827841C7F
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A452C1C255F6
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 07:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9272253E1A;
	Tue, 30 Jan 2024 07:22:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280F85103F;
	Tue, 30 Jan 2024 07:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706599363; cv=none; b=YBee6MN5lyBoPfVPjCZ7xVEa3J56lUugH2qU+PMdz2irPE9nV5/VhvgiFBPI8xD/tfMPIAvzWEAXsD1UxG3wsPnIQx4M5u7vAaBGCYIwlTIctelGJAPVogVrwC+kbYc8RKNbeg21IPT1ioy0wJ66jppHXpvb7jZc826c52mPESM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706599363; c=relaxed/simple;
	bh=s9M9qWXk7zaBkvkgi958JENo+Xs9EYVOYtq3eweY+VM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bzRTQUA5TmYD0SAoa+KV1DOqmMEPLLVMBGl/SUlmK/NCQuAyxTS+3fdW1J22D51+g/3WUtxEOEQeO1m/CTl+xGQtEyJPcVZ7/NmKK+d3V34MEUCjssqFdkLk7FJiMtg4nAFEfEFu3HGlAyf1DYxub8y+jKz2p112UyhPJQUk24Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxaOi_o7hlnzoIAA--.5782S3;
	Tue, 30 Jan 2024 15:22:39 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxXs2+o7hlPo4nAA--.20587S2;
	Tue, 30 Jan 2024 15:22:38 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] LoongArch: KVM: Start SW timer only when vcpu is blocking
Date: Tue, 30 Jan 2024 15:22:36 +0800
Message-Id: <20240130072238.2829831-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxXs2+o7hlPo4nAA--.20587S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWruF4rCF47WFWUJw45Xr45XFc_yoWfAFg_WF
	WDtFW5t3s7Wrs0yFnYk34rJa40gr1UA3yDXFyftr47tFW7AF98WF4Duay7uFW7Xa1xJFnr
	Xw4UWryxCw1aqosvyTuYvTs0mTUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUb28YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jUsqXUUUUU=

SW timer is enabled when vcpu thread is scheduled out, and it is
to wake up vcpu from blocked queue. If vcpu thread is scheduled out
however is not blocked, such as it is preempted by other threads,
it is not necessary to enable SW timer. Since vcpu thread is still
on running queue and SW timer is only to wake up tasks on blocking
queue, so SW timer is not useful in this situation.

This patch enables SW timer only when vcpu is scheduled out and
is blocking. Also when SW timer is expired, it only wakes up vcpu
thread in blocking queue and need not restart SW timer.

Bibo Mao (2):
  LoongArch: KVM: Start SW timer only when vcpu is blocking
  LoongArch: KVM: Do not restart SW timer when it is expired

 arch/loongarch/kvm/timer.c | 42 ++++++++------------------------------
 1 file changed, 9 insertions(+), 33 deletions(-)


base-commit: 41bccc98fb7931d63d03f326a746ac4d429c1dd3
-- 
2.39.3


