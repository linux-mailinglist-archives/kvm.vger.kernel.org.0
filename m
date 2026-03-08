Return-Path: <kvm+bounces-73232-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OG7iA8jOrGkHuwEAu9opvQ
	(envelope-from <kvm+bounces-73232-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 02:20:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ABFC22E34E
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 02:20:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9324D301E97A
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 01:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE58229B38;
	Sun,  8 Mar 2026 01:19:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F302110E;
	Sun,  8 Mar 2026 01:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772932791; cv=none; b=JWs5sENwkXCEomCmxg4yM5pCRc5mjM2K+VfTurhtHKDpSWyOkeS4bCjlUqdJ4no3vBg8V3/mxcV850DF+gsMYrZ0UYLWTzh5da7WoxRsb5zB2Gj4R6q+a2YlWR+18Ny/weLpSh6/8fxiLeV5EPh6gIjjoaXd6kYolX7olPhRYJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772932791; c=relaxed/simple;
	bh=Z/Ixav0e+wqHYrfHHBoHB0c5Hxy4y9wzi3e3jM/DKkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rt2Xu6RuPMziwuPg8vKkKd5l6U7K8gGb3x1E8QtLQZ4bv3Jc7IheoiKOIjKIaRwYIajkg3UBKmPM1JlTbI4o9RhxUvlrGzCuuDoB+S9KpzaDQRNrmozGLive4LAB+B51x9GTmm2hXfDBUY+1myzZfwv0kBozaNqXkT9zGfXg3sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowAA3yQyYzqxpAXvWCQ--.23484S2;
	Sun, 08 Mar 2026 09:19:20 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: andrew.jones@oss.qualcomm.com
Cc: ajones@ventanamicro.com,
	alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	jiakaiPeanut@gmail.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pjw@kernel.org,
	xujiakai2025@iscas.ac.cn
Subject: Re: [PATCH 1/2] RISC-V: KVM: Fix array out-of-bounds in pmu_ctr_read()
Date: Sun,  8 Mar 2026 01:19:19 +0000
Message-Id: <20260308011919.3891975-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <bcshd6j3vdeorxxmsmjmj5vi52mmivfe247aw77mr75zsk4llk@h3rxaqe23sb5>
References: <bcshd6j3vdeorxxmsmjmj5vi52mmivfe247aw77mr75zsk4llk@h3rxaqe23sb5>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3yQyYzqxpAXvWCQ--.23484S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WryDZFyDAFyUAr15KrWruFg_yoW8Aw1fpF
	Z3tFn0ya1xtFsrXFyxZr4DXr48Wwn3uFn8WrWrKryjgFs8JF97Wr4IkrWjkwsrCrn5WryS
	9a10gwn8C3WYvFJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWlnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67
	AK6w4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUrZ2-UUUU
	U
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBg0ACWmsPiSXUwAAsZ
X-Rspamd-Queue-Id: 4ABFC22E34E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-73232-lists,kvm=lfdr.de];
	DMARC_NA(0.00)[iscas.ac.cn];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[ventanamicro.com,ghiti.fr,brainfault.org,eecs.berkeley.edu,linux.dev,gmail.com,lists.infradead.org,vger.kernel.org,dabbelt.com,kernel.org,iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.686];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hi drew,

Thanks for the clarification.

> Any changes that come out of the pr_warn audit will result in a separate
> patch or patches. That work can be done completely separately and submit
> as a separate series. Or, if you do it right now, you could append those
> patches to this series. Either way works for me.

I will submit the pr_warn cleanup as a separate patch series later.

> That's good and we should do that, but we should also do negative testing.
> So there should be a test case where we try to read a counter without
> configuring it and ensure everything fails gracefully.

Agreed. In v2, I will update the selftests to include both positive tests 
and negative tests.

> > diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> > index 924a335d2262..0d6ba3563561 100644
> > --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> > +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> > @@ -461,7 +461,14 @@ static void test_pmu_basic_sanity(void)
> >  			pmu_csr_read_num(ctrinfo.csr);
> >  			GUEST_ASSERT(illegal_handler_invoked);
> >  		} else if (ctrinfo.type == SBI_PMU_CTR_TYPE_FW) {
> > -			read_fw_counter(i, ctrinfo);
> > +			/*
> > +			 * Try to configure with a common firmware event.
> > +			 * If configuration succeeds, verify we can read it.
> > +			 */
> > +			ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH,
> > +			        i, 1, 0, SBI_PMU_FW_ACCESS_LOAD, 0, 0);
> > +			if (ret.error == 0 && ret.value < RISCV_MAX_PMU_COUNTERS && BIT(ret.value) & counter_mask_available)
> 
> Put () around the & operator. checkpatch should have pointed that out.
> 

Noted, I will fix it in the next version.

> > +				read_fw_counter(i, ctrinfo);
> >  		}
> >  	}
> >  
> > -- 
> > 2.34.1
> >

I'll send out v2 shortly.

Thanks,
Jiakai


