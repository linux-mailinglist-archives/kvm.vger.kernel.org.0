Return-Path: <kvm+bounces-10043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF33E868CB4
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C75E1C21090
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545DF137C32;
	Tue, 27 Feb 2024 09:52:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14997BAE7;
	Tue, 27 Feb 2024 09:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709027535; cv=none; b=b+D9Rh6yVoMuweKenvFuULByrZ5mjhsB1qUWq91lGjSp0evC91vlMTtOUJMXiny++6syQqeVb3B+b3fJV8MdkzDEBHxpaNdYMct7FJizumEfK9J0Gm8VD10wKZLSJ5TtDRS+/sQ73q96KMKVHEVSbW9LfP6B1yVr/oNwDv00y1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709027535; c=relaxed/simple;
	bh=Cqn5IP45YhhILCijJAtbO8jWBeRWihbMdcIirdKca3Y=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mq0bKWtEGutt3mxh566diGaVL9hq0f85KMVNTImoJJ9uaAG5+urcHTBrYdsX0WA8a+Ho2BSmHN+xje6gm2KnbvZIw0yIvik1GuQoF7VfCao7ACjbBMSQ8Y2VIsHCqYmpXmtbvB8qITLsKBl+23qJs5z8XrB0WL7SixyPZkaz3b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8CxLOvKsN1lgeYRAA--.35251S3;
	Tue, 27 Feb 2024 17:52:10 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxfRPJsN1l2LZHAA--.26685S3;
	Tue, 27 Feb 2024 17:52:10 +0800 (CST)
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
To: Xi Ruoyao <xry111@xry111.site>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
 <CAAhV-H7p114hWUVrYRfKiBX3teG8sG7xmEW-Q-QT3i+xdLqDEA@mail.gmail.com>
 <06647e4a-0027-9c9f-f3bd-cd525d37b6d8@loongson.cn>
 <85781278-f3e9-4755-8715-3b9ff714fb20@app.fastmail.com>
 <0d428e30-07a8-5a91-a20c-c2469adbf613@loongson.cn>
 <09c5af9b-cc79-4cf2-84f7-276bb188754a@app.fastmail.com>
 <fc05cf09-bf53-158a-3cc9-eff6f06a220a@loongson.cn>
 <f1ba53fd2a99949187ca392c6d4488d3d5aeaf88.camel@xry111.site>
From: maobibo <maobibo@loongson.cn>
Message-ID: <e04a527b-2d9d-cfcd-e6ed-e8bd390649dd@loongson.cn>
Date: Tue, 27 Feb 2024 17:52:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f1ba53fd2a99949187ca392c6d4488d3d5aeaf88.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxfRPJsN1l2LZHAA--.26685S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7XrW7tryxtw4kAF48uF4kGrX_yoWfAwbE9r
	47tr9xAw1qyr4xG3y2y3y7CFW3Ga1DCFyqv3yxGas3W345JFyUWF1xuF1fA3WIqa4UZrn3
	CF1qq3yaqa4avosvyTuYvTs0mTUanT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbqkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j7BMNUUU
	UU=



On 2024/2/27 下午5:05, Xi Ruoyao wrote:
> On Tue, 2024-02-27 at 15:09 +0800, maobibo wrote:
> 
>> It is difficult to find an area unused by HW for CSR method since the
>> small CSR ID range.
> 
> We may use IOCSR instead.  In kernel/cpu-probe.c there are already some
> IOCSR reads.

yes, IOCSR can be used and one IOCSR area will be reserved for software. 
In general CSR/CPUCFG is to describe CPU features and IOCSR is to 
describe board/device features.

CSR area is limited to 16K, it is difficult for HW guys to reserve 
special area for software usage. IOCSR/CPUCFG is possible however.

Regards
Bibo Mao
> 
>> It is difficult to find an area unused by HW for CSR method since the
>> small CSR ID range. However it is easy for cpucfg. Here I doubt whether
>> you really know about LoongArch LVZ.
> 
> It's unfair to accuse the others for not knowing about LVZ considering
> the lack of public documentation.
> 


