Return-Path: <kvm+bounces-10720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF0886EFCF
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 10:27:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25297284557
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 09:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CC814296;
	Sat,  2 Mar 2024 09:27:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54AAF13FFA;
	Sat,  2 Mar 2024 09:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709371636; cv=none; b=CcQLJGD8vpUpEhvPb/1cofwytgYJFT4cA1yDzF5kEgQyJ2A8XZi5FWyXICUnJclH9p0cwLZ5jjicthiIFqyIu1sHv8mGRzpfD5XAXe+4hINV+4yzXPMWs5g3Fcqs1C5QQU0/ll28ma/q8U350HpwZqJfzjJLQ8mddwpTLiuXOHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709371636; c=relaxed/simple;
	bh=1v4MAWQqngr29S0hpMnjNmLuhvL8quZ03lPLgKrRH2k=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uNN+qfOITdO1rmAOEjv74ytHWem3ipvBuzaQ3KKzCxL5PuTF+XQiTnne5CARBs3OOHR/OCBvLM4Jx81Okr+k0+JtXxoDc/IeRIZQdBXSAGweVFal1jA39uaDyNs4ETrA1lv61vJoW+GcOPZjh8M0GBuLmfSt0ude/wQwkLfPjsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Dxfevv8OJlbowTAA--.49159S3;
	Sat, 02 Mar 2024 17:27:11 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxf8_r8OJlZWBMAA--.5897S3;
	Sat, 02 Mar 2024 17:27:10 +0800 (CST)
Subject: Re: [PATCH v6 0/7] LoongArch: Add pv ipi support on LoongArch VM
To: Xi Ruoyao <xry111@xry111.site>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20240302075120.1414999-1-maobibo@loongson.cn>
 <b2084dbd-3ea6-736a-293e-2309e828a960@loongson.cn>
 <562473e1080ce8a4d283cc8fb330073115b21019.camel@xry111.site>
From: maobibo <maobibo@loongson.cn>
Message-ID: <6ad837fb-6c0e-4586-4bd0-de00db3472dc@loongson.cn>
Date: Sat, 2 Mar 2024 17:27:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <562473e1080ce8a4d283cc8fb330073115b21019.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cxf8_r8OJlZWBMAA--.5897S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29K
	BjDU0xBIdaVrnRJUUUBGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26c
	xKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vE
	j48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
	ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E
	87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
	AS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCF54CYxVAaw2AFwI0_Jrv_JF1l4I8I3I0E
	4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxVWUJVWUGw
	C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
	MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
	IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2
	z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07j5WrAUUUUU=



On 2024/3/2 下午5:10, Xi Ruoyao wrote:
> On Sat, 2024-03-02 at 16:52 +0800, maobibo wrote:
>> Sorry for the noise. It seems that there is some problem with my mail
>> client when batch method.
>>
>> Please ignore this series, will send one by one manually.
> 
> Maybe you can try git send-email.
> 
yeap, git send-email --in-reply-to=xxx can be used to send the last two 
patches rather than discard the whole thread -:)

Thanks anyway.


