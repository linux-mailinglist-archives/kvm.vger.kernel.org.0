Return-Path: <kvm+bounces-4920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC2D819EF5
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 13:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 897A41F243F6
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 12:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BF922327;
	Wed, 20 Dec 2023 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vh0x0fRT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276262230D;
	Wed, 20 Dec 2023 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BKCMV9Y032700;
	Wed, 20 Dec 2023 12:26:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HQJJr1nge/MUXct9ZqOu2Vh12ig3RbcL0dlOr5B0cdk=;
 b=Vh0x0fRTfirBAHWaagIvDdPccIfd3GAoiVnkJUmVku17rugPJ4ZHXDhQQezxOL2GuBO7
 zc4rPSe+UcZOuV1Kt54idyTb3jbHwY90vlI7xbOFj+7/yssrDSCmBvfMHXTkm33x3u5k
 KzCDUDWJUNh+Vp0ycWG98DTkmR97i1RbZ7UkVC1HlV1enoxphApFwFvQlBB8hC3uBHwb
 erVwsDWs/9Vg332SmRjSk7peKSwGVu86bIbKtE6Kem5HNovGjK00v22k+NrU93V+IcBU
 NpWF6sk1rKDmNUMy5gzhL+rxdhLJvZGvr+4KUZpUXro3HalhuOlHXVncBgqxURTbBmwB cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v4077r2s4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 12:26:43 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BKCMrpe000626;
	Wed, 20 Dec 2023 12:26:42 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v4077r2ru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 12:26:42 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BKCMU0J027822;
	Wed, 20 Dec 2023 12:26:41 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3v1rek5xqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 12:26:41 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BKCQcke20316858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Dec 2023 12:26:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E004D2004B;
	Wed, 20 Dec 2023 12:26:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7528920043;
	Wed, 20 Dec 2023 12:26:38 +0000 (GMT)
Received: from [9.171.71.20] (unknown [9.171.71.20])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 Dec 2023 12:26:38 +0000 (GMT)
Message-ID: <5a035ab2-f704-470a-8b98-f8e5813ef08c@linux.ibm.com>
Date: Wed, 20 Dec 2023 13:26:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: vsie: fix race during shadow creation
To: David Hildenbrand <david@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20231220073400.257813-1-borntraeger@linux.ibm.com>
 <00f45b68-00cc-4cf1-a492-47d3bfce7e9f@redhat.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <00f45b68-00cc-4cf1-a492-47d3bfce7e9f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TmzQNdmZXgtVplwbAtb6LtFH5WoMRHTt
X-Proofpoint-GUID: oe4-H9RC5LAixCjf3qGRBfRwE7WSyoJ6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-20_02,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312200088



Am 20.12.23 um 11:39 schrieb David Hildenbrand:
> On 20.12.23 08:34, Christian Borntraeger wrote:
>> Right now it is possible to see gmap->private being zero in
>> kvm_s390_vsie_gmap_notifier resulting in a crash.  This is due to the
>> fact that we add gmap->private == kvm after creation:
>>
>> static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>>                                 struct vsie_page *vsie_page)
>> {
>> [...]
>>          gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
>>          if (IS_ERR(gmap))
>>                  return PTR_ERR(gmap);
>>          gmap->private = vcpu->kvm;
>>
>> Instead of tracking kvm in the shadow gmap, simply use the parent one.
>>
>> Cc: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>> ---
>>   arch/s390/kvm/vsie.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 8207a892bbe2..6b06d8ec41b5 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -579,14 +579,17 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>   void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
>>                    unsigned long end)
>>   {
>> -    struct kvm *kvm = gmap->private;
>>       struct vsie_page *cur;
>>       unsigned long prefix;
>>       struct page *page;
>> +    struct kvm *kvm;
>>       int i;
>>       if (!gmap_is_shadow(gmap))
>>           return;
>> +
>> +    kvm = gmap->parent->private;
>> +
>>       /*
>>        * Only new shadow blocks are added to the list during runtime,
>>        * therefore we can safely reference them all the time.
>> @@ -1220,7 +1223,6 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>>       gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
>>       if (IS_ERR(gmap))
>>           return PTR_ERR(gmap);
>> -    gmap->private = vcpu->kvm;
>>       vcpu->kvm->stat.gmap_shadow_create++;
>>       WRITE_ONCE(vsie_page->gmap, gmap);
>>       return 0;
> 
> Why not let gmap_shadow handle it? Simply clone the parent private field.
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 6f96b5a71c63..e083fade7a5d 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -1691,6 +1691,7 @@ struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce,
>                  return ERR_PTR(-ENOMEM);
>          new->mm = parent->mm;
>          new->parent = gmap_get(parent);
> +       new->private = patent->private;
>          new->orig_asce = asce;
>          new->edat_level = edat_level;
>          new->initialized = false;
> 
> Or am I missing something?

That would work as well. I discussed several alternatives with Janosch.
The only thing that bothers me is that the owner should define private. So an
alternative would be to have a parameter for gmap_shadow. On the other hand I
like the simplicity of this patch. (we need to get rid of the 2nd assignment
in acquire_gmap_shadow to make it complete.

So I can spin a v2 with this variant if Janosch is ok with it as well.


