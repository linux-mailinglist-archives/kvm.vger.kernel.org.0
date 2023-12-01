Return-Path: <kvm+bounces-3069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7446480048A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:16:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 591E71C20E2E
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 07:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441F712E48;
	Fri,  1 Dec 2023 07:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b+xga7mw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A9F171A
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 23:16:41 -0800 (PST)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1725a0004180;
	Fri, 1 Dec 2023 07:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BzkqJ/jGQ8feZTMTV7kBM2CKnfMMKrkrySy6iUP9EuY=;
 b=b+xga7mwfs1rp6LEevn9sUHSCU1lMKC/Z/EnZFVSkTZqk7CHQROyPzsnuQdIM07JAGOd
 ya+rGqq00S4Crr3b2meBlGLmSR+zVLKt6N0RKDFEL0B0+PyddOMnJ1Oo3KMNYy0V45Tp
 zQl06ERE0CoEmNthAoELlOyVtJJ5tOVa5/qwQCWWe44HfrE8ufDG2+WNPURfGtiA7LjI
 gEQQwLy0ElzkEJ/RfK3dlxHsbtQvtJbXCubTiiy4RG3biUGoEqTvt7IqDZAaduT8B7ug
 IPbSIbm/F1XOJB6WbUJbwyRiB0naqI1VwIbtR2szxG9CAwjLNMBiE/wFu+M9Q33M+Xk/ eA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqar7gaus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 07:15:41 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B17FebO014948;
	Fri, 1 Dec 2023 07:15:40 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqar7ga27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 07:15:40 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B16Ye5v029654;
	Fri, 1 Dec 2023 07:11:06 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukv8p3h96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 07:11:06 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B17B5Ah30016124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 07:11:05 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A81A58052;
	Fri,  1 Dec 2023 07:11:05 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CEAB58054;
	Fri,  1 Dec 2023 07:10:35 +0000 (GMT)
Received: from [9.43.126.227] (unknown [9.43.126.227])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  1 Dec 2023 07:10:35 +0000 (GMT)
Message-ID: <6debe854-55df-e901-e154-5ed390178c74@linux.ibm.com>
Date: Fri, 1 Dec 2023 12:40:33 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 2/6] qemu/main-loop: rename QEMU_IOTHREAD_LOCK_GUARD to
 QEMU_BQL_LOCK_GUARD
Content-Language: en-US
To: Stefan Hajnoczi <stefanha@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc: qemu-devel@nongnu.org, Jean-Christophe Dubois <jcd@tribudubois.net>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,
        Thomas Huth <thuth@redhat.com>, Hyman Huang <yong.huang@smartx.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>, Artyom Tarasenko <atar4qemu@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Paul Durrant <paul@xen.org>, Jagannathan Raman <jag.raman@oracle.com>,
        Juan Quintela
 <quintela@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?=
 <berrange@redhat.com>,
        qemu-arm@nongnu.org, Jason Wang
 <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Hailiang Zhang <zhanghailiang@xfusion.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Huacai Chen <chenhuacai@kernel.org>, Fam Zheng <fam@euphon.net>,
        Eric Blake <eblake@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Alexander Graf <agraf@csgraf.de>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Weiwei Li <liwei1518@gmail.com>, Eric Farman <farman@linux.ibm.com>,
        Stafford Horne <shorne@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Cameron Esfahani <dirty@apple.com>, xen-devel@lists.xenproject.org,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, qemu-riscv@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        John Snow <jsnow@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Michael Roth <michael.roth@amd.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Bin Meng <bin.meng@windriver.com>,
        Stefano Stabellini <sstabellini@kernel.org>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>, qemu-ppc@nongnu.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>,
        Leonardo Bras
 <leobras@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20231129212625.1051502-1-stefanha@redhat.com>
 <20231129212625.1051502-3-stefanha@redhat.com>
 <c3ac8d9c2b9d611e84672436ce1a96aedcaacf5e.camel@linux.ibm.com>
 <20231130202732.GA1184658@fedora>
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20231130202732.GA1184658@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S1sEqcNGAK1f1yUwyiWHNf41PAnYA7MY
X-Proofpoint-GUID: B-XJS9KsqjYFS8Hl-N4F0TWzVhOEzlLk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_04,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxlogscore=778 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010044



On 12/1/23 01:57, Stefan Hajnoczi wrote:
> On Thu, Nov 30, 2023 at 10:14:47AM +0100, Ilya Leoshkevich wrote:
>> On Wed, 2023-11-29 at 16:26 -0500, Stefan Hajnoczi wrote:
>>> The name "iothread" is overloaded. Use the term Big QEMU Lock (BQL)
>>> instead, it is already widely used and unambiguous.
>>>
>>> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> ---
>>>   include/qemu/main-loop.h  | 20 ++++++++++----------
>>>   hw/i386/kvm/xen_evtchn.c  | 14 +++++++-------
>>>   hw/i386/kvm/xen_gnttab.c  |  2 +-
>>>   hw/mips/mips_int.c        |  2 +-
>>>   hw/ppc/ppc.c              |  2 +-
>>>   target/i386/kvm/xen-emu.c |  2 +-
>>>   target/ppc/excp_helper.c  |  2 +-
>>>   target/ppc/helper_regs.c  |  2 +-
>>>   target/riscv/cpu_helper.c |  4 ++--
>>>   9 files changed, 25 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/include/qemu/main-loop.h b/include/qemu/main-loop.h
>>> index d6f75e57bd..0b6a3e4824 100644
>>> --- a/include/qemu/main-loop.h
>>> +++ b/include/qemu/main-loop.h
>>> @@ -344,13 +344,13 @@ void qemu_bql_lock_impl(const char *file, int
>>> line);
>>>   void qemu_bql_unlock(void);
>>>   
>>>   /**
>>> - * QEMU_IOTHREAD_LOCK_GUARD
>>> + * QEMU_BQL_LOCK_GUARD
>>>    *
>>> - * Wrap a block of code in a conditional
>>> qemu_mutex_{lock,unlock}_iothread.
>>> + * Wrap a block of code in a conditional qemu_bql_{lock,unlock}.
>>>    */
>>> -typedef struct IOThreadLockAuto IOThreadLockAuto;
>>> +typedef struct BQLLockAuto BQLLockAuto;
>>>   
>>> -static inline IOThreadLockAuto *qemu_iothread_auto_lock(const char
>>> *file,
>>> +static inline BQLLockAuto *qemu_bql_auto_lock(const char *file,
>>>                                                           int line)
>>
>> The padding is not correct anymore.
> 
> Good point, I didn't check the formatting after search-and-replace. I
> will fix this across the patch series in v2.
> 

Yeh, some comments in 5/6 and 6/6 can also make full use of 80 char 
width after search-replace effect.

regards,
Harsh

> Stefan

