Return-Path: <kvm+bounces-59044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD52ABAA9D4
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 22:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7019F16FCCC
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E810258ECC;
	Mon, 29 Sep 2025 20:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OH1hPajq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CF71EB9E3
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 20:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759179532; cv=none; b=PhZkUGMle0besqbwaXK/qztug1JfJZCw8OAFnHsbDWIpdqGF+scEA21ZbJIFr2tW9zURUo8Vpg4ioavSX7+CzhixjYUsCC/tB2vt42w/wbIIImU8wyQYMSqhmKBFvmENpXDYzymVQIeveW96GBkLvuhi4cBRNXQUlCxnLjiQMYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759179532; c=relaxed/simple;
	bh=J76N2wEur0Y+i5AoxNHpEXUoeTsTOvVmp7a7y+pNgkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=awxBTsUcDDBKnqDlsW8hu4+dzOHPaLXyenxWBkmWBYpRJyCLu8n/l5IQs++nEDgssiEZmCdcQTrnrTBWG8NOLo9ysTeYac//dMbuiZ95SGmfhmDmYMrKbE1U4f7sWTH3ueYJw/nF0qwD7FJEusqqw5mItMfIvNBLORE8b4v9KwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OH1hPajq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759179529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGlYEFRv8xDNhpiiWlWf8YqSTaYSiFOP+ymflG4dl6g=;
	b=OH1hPajqlf7JW6d25VMxLH1ryiNLn7yZk112Ym1dBTmlQ/smJfhveVbwrQHQC2HRROF5jh
	5SXQW+D9ir6WVkx2SH+3/Csv92yw89GsxEAmre9jfeN/rbGJZhmCeYsJjc0Fz4/gzKw10N
	RhC+PcyHlI1usHdmYvvVMlxyQWZog5c=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-DBV9PB2iMjGBdpNhI_us9A-1; Mon, 29 Sep 2025 16:58:47 -0400
X-MC-Unique: DBV9PB2iMjGBdpNhI_us9A-1
X-Mimecast-MFC-AGG-ID: DBV9PB2iMjGBdpNhI_us9A_1759179527
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-78f2b1bacfcso88882756d6.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 13:58:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759179526; x=1759784326;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGlYEFRv8xDNhpiiWlWf8YqSTaYSiFOP+ymflG4dl6g=;
        b=H3pi+o+xCH5j2Jw0Zr3Bac+I728B5cE1Psrihv8sQQtqvZSGFrtGp/fStFZW+2NROC
         ShZpLnLM/XEAaCR3d5XaGFy3QUBW0sbbu3kQz8BBF7AZtqB1ax4QS4o4NOT0B6TpIRgS
         WSnEs2wqwTs5yr8HvrOBoTXYaWXR/29zWJmL2XaTNfTHxw8vBklwK0HZXC8NGMtKAVBf
         N8qvvOOtsFrYr2ce0wzzGa/TneZEIpIIg65KdF+QM8Bg03jumj0uSn5s96VBb6E7H6z1
         E8D3o7WQAFbNPU6UucCMP0gn75ZvxcpzGV2FO0Tw/vHljssAPPeFsBnzmnjGK0baVO/e
         AhTQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7tp9I1BGYRAJsb+wRi+TDhHDvq+PRXXrfbOEpDby0q8mlecsd7T4gPEVRdRiOyqlh7uI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNQk2B5jDcmEAU7xDiO3JyOIRAgDY+jB/4gxaidhdPaIRQsGb/
	7ZGoiUyYwbHbQqiK+qUeZ2doU5Hry1mApbSoIvACkOpGQvskshmKF9uefffykoq/OtF47098po+
	I7zcCryxcEqoybC6Bko8LFVdAXPxoZXyEzv0fF+SKAQagR+O6pH1fHg==
X-Gm-Gg: ASbGncsoMtkf+gYkAOMbA1Nde2r6olGrgCVupdlCSlex3H1W4+TdBxrc3jkajQ48a29
	1K4K9GV7jNFvILX+qHkssnyWUc8I182CzW0tU5piVpxXBuW0i/9rh/gwIbmYVqnKXKxoaKUC6yL
	mqVjrcQZrCXanhcyk6PNCkwLZbwpBhYTQjg0bQHq67i06vqx94biIvw/ZDS1qPyhmc1G7KQEYHK
	cHM8XgaN98LZSB6YxPO1jGcVr7qTv2OPgh5l9b6vR0398AMiVJ1jBFVeTabSwqdEEC46EKoRKI/
	80GtJT6s2yavl3jDjepx/FBc5HPIAcJ6
X-Received: by 2002:a05:620a:a00d:b0:85c:3bcf:e843 with SMTP id af79cd13be357-85c3bcfeaa1mr2112609285a.43.1759179526135;
        Mon, 29 Sep 2025 13:58:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDVAfO10gZpyYJ8dwCVcOEIU84P0ACyRABeDGvxvxzPh4CJm5bPu8NN+2BKbE3WeVcAszc+g==
X-Received: by 2002:a05:620a:a00d:b0:85c:3bcf:e843 with SMTP id af79cd13be357-85c3bcfeaa1mr2112601685a.43.1759179525509;
        Mon, 29 Sep 2025 13:58:45 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-85c2a1913d5sm893653985a.31.2025.09.29.13.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 13:58:45 -0700 (PDT)
Date: Mon, 29 Sep 2025 16:58:41 -0400
From: Peter Xu <peterx@redhat.com>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Cc: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	qemu-devel@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
	Steven Lee <steven_lee@aspeedtech.com>,
	Troy Lee <leetroy@gmail.com>, Jamin Lin <jamin_lin@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Joel Stanley <joel@jms.id.au>, Eric Auger <eric.auger@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?utf-8?B?SGVydsOp?= Poussineau <hpoussin@reactos.org>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	Ninad Palsule <ninad@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
	=?utf-8?Q?Cl=C3=A9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Aditya Gupta <adityag@linux.ibm.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Song Gao <gaosong@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	Subbaraya Sundeep <sundeep.lkml@gmail.com>,
	Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Bernhard Beschow <shentey@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
	Bin Meng <bmeng.cn@gmail.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	qemu-block@nongnu.org, kvm@vger.kernel.org,
	Alex Williamson <alex.williamson@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>
Subject: Re: [PATCH 00/35] memory: QOM-ify AddressSpace
Message-ID: <aNrzASvJCP_axv22@x1.local>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
 <a06a989d-b685-4e62-be06-d96fb91ed6ea@redhat.com>
 <61e4c2bb-d8fa-446a-b4ec-027d4eae35b5@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61e4c2bb-d8fa-446a-b4ec-027d4eae35b5@rsg.ci.i.u-tokyo.ac.jp>

On Thu, Sep 18, 2025 at 09:47:07PM +0900, Akihiko Odaki wrote:
> On 2025/09/18 21:39, Cédric Le Goater wrote:
> > Hello Akihiko,
> > 
> > On 9/17/25 14:56, Akihiko Odaki wrote:
> > > Based-on: <20250917-subregion-v1-0-bef37d9b4f73@rsg.ci.i.u-tokyo.ac.jp>
> > > ("[PATCH 00/14] Fix memory region use-after-finalization")
> > > 
> > > Make AddressSpaces QOM objects to ensure that they are destroyed when
> > > their owners are finalized and also to get a unique path for debugging
> > > output.
> > > 
> > > Suggested by BALATON Zoltan:
> > > https://lore.kernel.org/qemu-devel/cd21698f-db77-eb75-6966-
> > > d559fdcab835@eik.bme.hu/
> > > 
> > > Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> > 
> > I wonder if this is going to fix an issue I was seeing a while ago
> > in the FSI models. I couldn't find a clean way to avoid corrupting
> > memory because of how the address_space was created and later on
> > destroyed. See below,
> 
> Partially, but this is insufficient.
> 
> The first problem is that AddressSpace suffers from circular references the
> following series solves:
> https://lore.kernel.org/qemu-devel/20250906-mr-v2-0-2820f5a3d282@rsg.ci.i.u-tokyo.ac.jp/
> "[PATCH v2 0/3] memory: Stop piggybacking on memory region owners"
> 
> Another problem is that RCU is not properly waited. This is left to future
> work.

Just to mention, Peter Maydell just posted a series for fixing AS
destructions here:

https://lore.kernel.org/qemu-devel/20250929144228.1994037-1-peter.maydell@linaro.org/

IIUC it should also work for FSI, if FSI can convert to use dynamically
allocated AddressSpaces (with/without QOMify; as Akihiko pointed out
correctly, these should be orthogonal), then provide a proper unrealize()
of the bus device to invoke address_space_destroy_free().

Thanks,

-- 
Peter Xu


