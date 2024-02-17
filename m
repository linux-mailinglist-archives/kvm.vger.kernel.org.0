Return-Path: <kvm+bounces-8951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DF89858D0C
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 04:15:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 227761F23017
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 03:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57AD1BDF4;
	Sat, 17 Feb 2024 03:15:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2703D71;
	Sat, 17 Feb 2024 03:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708139708; cv=none; b=Fh1Z9kqFb2DyZnWPyp8uGvkSuFWsAzUtVjF0IKy5wDaimB0l2g1m0T8Fm5OHsQKJqyFHBMmi8T/z8fHhfFf4gwXf9EtVdZX4YM+lBSZXjl0QRGe45wudGoBZDoUleL0PQK7vAr6TS9LFWHEtNXvB3o00ph++XpZ+xQMbBZw0KyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708139708; c=relaxed/simple;
	bh=B4/7/MrEpWq6X2d3hcZTW3hwhCv2dGfQTMCg58XpiZs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mhQ/c7zLJbAhqu+1yxQT9WNH7TEGekWXdrfrADXckhKCHRkwu53HRznxxYvEUuZB06Qgi+TJhxRaGycbSt5C/aidvsrlIEmvBjweCQCUo5wfmN2t2CdpSSCIYdPV9JO6ILhmAHXcOU/w/lFmXobFxIlWUE91m+GjgS6vAbuGr6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8CxLOu4JNBla_ENAA--.27167S3;
	Sat, 17 Feb 2024 11:15:04 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrhO1JNBlxt04AA--.23729S3;
	Sat, 17 Feb 2024 11:15:03 +0800 (CST)
Subject: Re: [PATCH v4 0/6] LoongArch: Add pv ipi support on LoongArch VM
To: WANG Xuerui <kernel@xen0n.name>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240201031950.3225626-1-maobibo@loongson.cn>
 <0f4d83e2-bff9-49d9-8066-9f194ce96306@xen0n.name>
 <447f4279-aea9-4f35-b87e-a3fc8c6c20ac@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <4a6e25ec-cdb6-887a-2c64-3df12d30c89a@loongson.cn>
Date: Sat, 17 Feb 2024 11:15:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <447f4279-aea9-4f35-b87e-a3fc8c6c20ac@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrhO1JNBlxt04AA--.23729S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWrXw4kKw4fKryUKF4kGryxCrX_yoWxXrg_WF
	y0qr4DAwsrJrsrKw4fKrsYq3srGFWUtr90q3Z7Xw4FgryUXFZ8Ja4DJ393ZanIqF4xtF98
	Kw1kCay5uF1ayosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbxkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
	JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8wNVDUU
	UUU==



On 2024/2/15 下午6:25, WANG Xuerui wrote:
> On 2/15/24 18:11, WANG Xuerui wrote:
>> Sorry for the late reply (and Happy Chinese New Year), and thanks for 
>> providing microbenchmark numbers! But it seems the more comprehensive 
>> CoreMark results were omitted (that's also absent in v3)? While the 
> 
> Of course the benchmark suite should be UnixBench instead of CoreMark. 
> Lesson: don't multi-task code reviews, especially not after consuming 
> beer -- a cup of coffee won't fully cancel the influence. ;-)
> 
Where is rule about benchmark choices like UnixBench/Coremark for ipi 
improvement?

Regards
Bibo Mao


