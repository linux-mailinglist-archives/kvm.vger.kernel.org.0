Return-Path: <kvm+bounces-58005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AF9AB848F0
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:22:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BED83B3CA9
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A522E0902;
	Thu, 18 Sep 2025 12:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="ncih+7Z+"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCABA34BA28
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 12:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758198117; cv=none; b=AoJt32o56filgKrlIJBMC2kim4m4Y6LDf+HBz469xgvDzBF91kS/u/AUNPHVxkccR9IT+kXsZ3Z+uLaodCi4Q6uOVQIsH1+1Clf+Yich28ZWJ449AHGM808qGCUXtDxpVDUXo82Hpkso91LEMSyzPjWhrCMFutlFBWv18Md5qI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758198117; c=relaxed/simple;
	bh=yQN4Ex0/3FLqMZwCGNRTF46u2kK8avLbUJVaAxbTMRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u5KTzIgseQtCqjMK89xXCTmvhlY8bC/qIge+MUG4YzKlnNcyQ25K2dzPYjTEfqbdeofJLtQsD/+jDbSQIdw9m5KvwquQbOTtS4TnbuY4Ya74KxPFnxXNMvvi5UDJd+vIK5q18knc3UXlmpjUO/mhNiPseIF48rmoBlQRfjEIxg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=ncih+7Z+ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58ICGpZG015138
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 18 Sep 2025 21:16:51 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=3gRH8iNZdxrVCMmHBiEB8svHVHUJgh9SBiCdxh/rErs=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1758197812; v=1;
        b=ncih+7Z+Iq77ZtsPGIxVnHq3UyoofFR20q9ukLu6ggyhvkeM45o26pRuiRlZ1ygh
         bvqO9pqoDi51Bf469GDustGnkMvrOEYx4wq8iBHvNa3HVx7dKZYyAnOf1hAOhiZ0
         az4UCk701ZUURs8HqyU+Z0Y9TPDhCGVp08jn/fEGcCYTn+FZFPz5Elk6K/jRsBiL
         osyUPH7CV8Rke50bdhKV1bwJxrKeDaiy3Sh9hDX+K1T8ORUPQi3kiDCUYviJNCSY
         pAj32hWZ36YLEvwHNuKual9bk3SHAzSByqEF72lW1YRUpFE4CjJn3yUuSdJZniJ7
         O6E2XhUYZW2FNZ+4108QOg==
Message-ID: <819cdc32-23f4-4517-bc67-600d3ecce133@rsg.ci.i.u-tokyo.ac.jp>
Date: Thu, 18 Sep 2025 21:16:51 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/35] hw/i386: QOM-ify AddressSpace
To: CLEMENT MATHIEU--DRIF <clement.mathieu--drif@eviden.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>,
        Steven Lee <steven_lee@aspeedtech.com>, Troy Lee <leetroy@gmail.com>,
        Jamin Lin <jamin_lin@aspeedtech.com>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>, Eric Auger <eric.auger@redhat.com>,
        Helge Deller <deller@gmx.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <arikalo@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        Ninad Palsule <ninad@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin"
 <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Aditya Gupta <adityag@linux.ibm.com>,
        Gautam Menghani <gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>,
        Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>,
        Andrey Smirnov
 <andrew.smirnov@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Bernhard Beschow <shentey@gmail.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Palmer Dabbelt
 <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        Bin Meng <bmeng.cn@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>, Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>,
        "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
        "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
 <20250917-qom-v1-10-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
 <d571d1aa47ddbf466e9e8edf1cbb7d29f3bb0a83.camel@eviden.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <d571d1aa47ddbf466e9e8edf1cbb7d29f3bb0a83.camel@eviden.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/09/18 14:53, CLEMENT MATHIEU--DRIF wrote:
> Hi Akihiko,
> 
> Why do we change the naming scheme in amd-vi?
> Did you have any issue with the old one?

QOM-ifying AddressSpaces moves the responsibility to create distinct 
identifiers for debug outputs from the callers of address_space_init() 
to AddressSpaces. QOM-ified AddressSpaces can create unique, unambigous 
identifiers by inspecting the QOM hierarchy and cover all devices, not 
just amd-iommu.

> 
> If we decide not to stick to the old one, maybe splitting the slot and function would be convenient.

Strictly speaking such a change is an out-of-scope of this patch, but it 
won't hurt to have it. I'll make the change with the next version.

Regards,
Akihiko Odaki

