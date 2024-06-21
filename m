Return-Path: <kvm+bounces-20198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BFA911841
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 04:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A63D2834A6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 02:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835FC82D70;
	Fri, 21 Jun 2024 02:00:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E5982C6B;
	Fri, 21 Jun 2024 01:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718935200; cv=none; b=M8bdg8AKwmSxYa3eVI8fXE5IPlp5uHPbNu7QCDSZrKvTQGhz34b2zjGjZ6lQF6xvHOmioeXGQ9MC2nKdc2fplVmEHrW3sYeuevoLp7VkVu3X3BKlWhaka0NBGnHzw7y60WTlMvcrWWkWvGah8BlWHExt6iADZ/IkwDlqSEnksGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718935200; c=relaxed/simple;
	bh=5RB2rtDi4hm5oR1GoFhNL6bWdRUdH2juJfA+0seYFks=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uISaesGs07ZvLrYHXqv+Y5uehuBVd0I21FOfu5QoDxATSHmxZYUAPR25A7ZCXxVCODq0BP+hhm9WRiLCmoSxHc/7UJmHKk94BQkTQksGAcVWcQ0EsGzEaW8IQeGmcWFKKdhO7bt1liZ08ekG/PzcUb9BMu4TpQjFMm/qk4TkDS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Dx2OmX3nRmI7oIAA--.22764S3;
	Fri, 21 Jun 2024 09:59:52 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxBMWV3nRmYe8qAA--.27667S3;
	Fri, 21 Jun 2024 09:59:51 +0800 (CST)
Subject: Re: [PATCH] KVM: Remove duplicated zero clear with dirty_bitmap
 buffer
To: Paolo Bonzini <pbonzini@redhat.com>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240613125407.1126587-1-maobibo@loongson.cn>
 <115973a9-caa6-4d53-a477-dea2d2291598@wanadoo.fr>
 <fb2da53e-791d-aef7-4dbb-dcf054675f9b@loongson.cn>
 <5a2b21ce-2554-4ee8-bff1-76231ea77703@redhat.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <e4d78c69-c723-758e-374c-514088d8f961@loongson.cn>
Date: Fri, 21 Jun 2024 09:59:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5a2b21ce-2554-4ee8-bff1-76231ea77703@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxBMWV3nRmYe8qAA--.27667S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWrKw4DZw4fGr18CF1fGrWfJFc_yoWfZrXE9F
	W2qFyvg3y5Wrs7Zay2g3yS9FZrKayvqry0qw18XryrK34fJwsrC3Z5KFWruFyxJFnrKr90
	kr9rAryIvFnIqosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
	JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwmhFDUUU
	U



On 2024/6/21 上午5:17, Paolo Bonzini wrote:
> On 6/14/24 04:45, maobibo wrote:
>> I do not know whether KVM_DIRTY_LOG_INITIALLY_SET should be enabled on 
>> LoongArch. If it is set, write protection for second MMU will start 
>> one by one in function kvm_arch_mmu_enable_log_dirty_pt_masked() when 
>> dirty log is cleared if it is set, else write protection will start in 
>> function kvm_arch_commit_memory_region() when flag of memslot is changed.
>>
>> I do not see the obvious benefits between these two write protect 
>> stages. Can anyone give me any hints?
> 
> The advantage is that you get (a lot) fewer vmexits to set the dirty 
> bitmap, and that write protection is not done in a single expensive 
> step.  Instead it is done at the time that userspace first clears the 
> bits in the dirty bitmap.  It provides much better performance.
Got it, thanks for the explanation .

Regards
Bibo Mao
> 
> Paolo
> 


