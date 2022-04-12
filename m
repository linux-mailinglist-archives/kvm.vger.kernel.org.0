Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AB44FE5AE
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 18:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357520AbiDLQU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 12:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbiDLQU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 12:20:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72341580E2;
        Tue, 12 Apr 2022 09:18:39 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CEn3Iq012647;
        Tue, 12 Apr 2022 16:18:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QI4ZW6SETdXwueS2ga/ZXpFdxP9ki2F3jJY3ZeFnHWo=;
 b=ndCBqPIxCmTWzheR88TYcpI/0i5v264UXWlG327BWBlQ8dTLqO4G8US7aFXknimTwZ5a
 IrBjmcrCciVa00nbtMM1ozorwIqINzGkjpL6pGDxKdN1j7Lm6BA0pzfG5Oscd7fCPxRd
 mTRWyWZK1+5tneMY4Lilh2WS4LSbUhbM79k+q87bBr7q92GE5HcYCnTL0u+P94klsgxZ
 qTY9s2rp0JWtSto5azsQiwc/pQFjpiZ3yMvskwISweN7D1W3t7V/lkepiqczwyTz2OOK
 aV6yQi/rbgzN6Y4Z6rhShjM7ZXCwRJVueO34mMOw/XiPqXPSEfekZuvdVQjNXHEFXH+7 iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdayku1gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 16:18:38 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CFqbWK026322;
        Tue, 12 Apr 2022 16:18:38 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdayku1g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 16:18:37 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CGDv2J027611;
        Tue, 12 Apr 2022 16:18:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3fb1s8v7hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 16:18:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CGIWCh47645118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 16:18:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CBDF4C046;
        Tue, 12 Apr 2022 16:18:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DCB44C04A;
        Tue, 12 Apr 2022 16:18:31 +0000 (GMT)
Received: from [9.171.87.149] (unknown [9.171.87.149])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 16:18:31 +0000 (GMT)
Message-ID: <eeda0d14-270a-971a-900d-8b55a1f020c8@linux.ibm.com>
Date:   Tue, 12 Apr 2022 18:18:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 08/21] s390/pci: stash associated GISA designation
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-9-mjrosato@linux.ibm.com>
 <3148aa6225912b59a95c6bdff3a5b03f8e4e8366.camel@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <3148aa6225912b59a95c6bdff3a5b03f8e4e8366.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MWXWHKc2qqa-KIadnBQnq1rUSc6aY_Hd
X-Proofpoint-ORIG-GUID: Zdcp-pMtxcU_C0yPTIBsYThWoxa0ZZVu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120077
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 05.04.22 um 10:03 schrieb Niklas Schnelle:
> On Mon, 2022-04-04 at 13:43 -0400, Matthew Rosato wrote:
>> For passthrough devices, we will need to know the GISA designation of the
>> guest if interpretation facilities are to be used.  Setup to stash this in
>> the zdev and set a default of 0 (no GISA designation) for now; a subsequent
>> patch will set a valid GISA designation for passthrough devices.
>> Also, extend mpcific routines to specify this stashed designation as part
>> of the mpcific command.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

>> ---
>>   arch/s390/include/asm/pci.h     | 1 +
>>   arch/s390/include/asm/pci_clp.h | 3 ++-
>>   arch/s390/pci/pci.c             | 6 ++++++
>>   arch/s390/pci/pci_clp.c         | 5 +++++
>>   arch/s390/pci/pci_irq.c         | 5 +++++
>>   5 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index fdb9745ee998..42a4a312a6dd 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -123,6 +123,7 @@ struct zpci_dev {
>>   	enum zpci_state state;
>>   	u32		fid;		/* function ID, used by sclp */
>>   	u32		fh;		/* function handle, used by insn's */
>> +	u32		gisa;		/* GISA designation for passthrough */
>>   	u16		vfn;		/* virtual function number */
>>   	u16		pchid;		/* physical channel ID */
>>   	u8		pfgid;		/* function group ID */
>> diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
>> index 1f4b666e85ee..f3286bc5ba6e 100644
>> --- a/arch/s390/include/asm/pci_clp.h
>> +++ b/arch/s390/include/asm/pci_clp.h
>> @@ -173,7 +173,8 @@ struct clp_req_set_pci {
>>   	u16 reserved2;
>>   	u8 oc;				/* operation controls */
>>   	u8 ndas;			/* number of dma spaces */
>> -	u64 reserved3;
>> +	u32 reserved3;
>> +	u32 gisa;			/* GISA designation */
>>   } __packed;
>>   
>>   /* Set PCI function response */
>> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
>> index e563cb65c0c4..a86cd1cbb80e 100644
>> --- a/arch/s390/pci/pci.c
>> +++ b/arch/s390/pci/pci.c
>> @@ -120,6 +120,7 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
>>   	fib.pba = base;
>>   	fib.pal = limit;
>>   	fib.iota = iota | ZPCI_IOTA_RTTO_FLAG;
>> +	fib.gd = zdev->gisa;
>>   	cc = zpci_mod_fc(req, &fib, &status);
>>   	if (cc)
>>   		zpci_dbg(3, "reg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
>> @@ -133,6 +134,8 @@ int zpci_unregister_ioat(struct zpci_dev *zdev, u8 dmaas)
>>   	struct zpci_fib fib = {0};
>>   	u8 cc, status;
>>   
>> +	fib.gd = zdev->gisa;
> 
> This could go into the initializer which becomes:
> 
>     struct zpci_fib fib = {.gd = zdev->gisa};
> 
>> +
>>   	cc = zpci_mod_fc(req, &fib, &status);
>>   	if (cc)
>>   		zpci_dbg(3, "unreg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
>> @@ -160,6 +163,7 @@ int zpci_fmb_enable_device(struct zpci_dev *zdev)
>>   	atomic64_set(&zdev->unmapped_pages, 0);
>>   
>>   	fib.fmb_addr = virt_to_phys(zdev->fmb);
>> +	fib.gd = zdev->gisa;
>>   	cc = zpci_mod_fc(req, &fib, &status);
>>   	if (cc) {
>>   		kmem_cache_free(zdev_fmb_cache, zdev->fmb);
>> @@ -178,6 +182,8 @@ int zpci_fmb_disable_device(struct zpci_dev *zdev)
>>   	if (!zdev->fmb)
>>   		return -EINVAL;
>>   
>> +	fib.gd = zdev->gisa;
>> +
>>   	/* Function measurement is disabled if fmb address is zero */
>>   	cc = zpci_mod_fc(req, &fib, &status);
>>   	if (cc == 3) /* Function already gone. */
>> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
>> index 1057d7af4a55..deed35edea14 100644
>> --- a/arch/s390/pci/pci_clp.c
>> +++ b/arch/s390/pci/pci_clp.c
>> @@ -229,12 +229,16 @@ static int clp_set_pci_fn(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as, u8 comma
>>   {
>>   	struct clp_req_rsp_set_pci *rrb;
>>   	int rc, retries = 100;
>> +	u32 gisa = 0;
>>   
>>   	*fh = 0;
>>   	rrb = clp_alloc_block(GFP_KERNEL);
>>   	if (!rrb)
>>   		return -ENOMEM;
>>   
>> +	if (command != CLP_SET_DISABLE_PCI_FN)
>> +		gisa = zdev->gisa;
>> +
>>   	do {
>>   		memset(rrb, 0, sizeof(*rrb));
>>   		rrb->request.hdr.len = sizeof(rrb->request);
>> @@ -243,6 +247,7 @@ static int clp_set_pci_fn(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as, u8 comma
>>   		rrb->request.fh = zdev->fh;
>>   		rrb->request.oc = command;
>>   		rrb->request.ndas = nr_dma_as;
>> +		rrb->request.gisa = gisa;
>>   
>>   		rc = clp_req(rrb, CLP_LPS_PCI);
>>   		if (rrb->response.hdr.rsp == CLP_RC_SETPCIFN_BUSY) {
>> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
>> index f2b3145b6697..a2b42a63a53b 100644
>> --- a/arch/s390/pci/pci_irq.c
>> +++ b/arch/s390/pci/pci_irq.c
>> @@ -43,6 +43,7 @@ static int zpci_set_airq(struct zpci_dev *zdev)
>>   	fib.fmt0.aibvo = 0;	/* each zdev has its own interrupt vector */
>>   	fib.fmt0.aisb = virt_to_phys(zpci_sbv->vector) + (zdev->aisb / 64) * 8;
>>   	fib.fmt0.aisbo = zdev->aisb & 63;
>> +	fib.gd = zdev->gisa;
>>   
>>   	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
>>   }
>> @@ -54,6 +55,8 @@ static int zpci_clear_airq(struct zpci_dev *zdev)
>>   	struct zpci_fib fib = {0};
>>   	u8 cc, status;
>>   
>> +	fib.gd = zdev->gisa;
>> +
> 
> Same as in zpci_register_ioat()
> 
>>   	cc = zpci_mod_fc(req, &fib, &status);
>>   	if (cc == 3 || (cc == 1 && status == 24))
>>   		/* Function already gone or IRQs already deregistered. */
>> @@ -72,6 +75,7 @@ static int zpci_set_directed_irq(struct zpci_dev *zdev)
>>   	fib.fmt = 1;
>>   	fib.fmt1.noi = zdev->msi_nr_irqs;
>>   	fib.fmt1.dibvo = zdev->msi_first_bit;
>> +	fib.gd = zdev->gisa;
>>   
>>   	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
>>   }
>> @@ -84,6 +88,7 @@ static int zpci_clear_directed_irq(struct zpci_dev *zdev)
>>   	u8 cc, status;
>>   
>>   	fib.fmt = 1;
>> +	fib.gd = zdev->gisa;
>>   	cc = zpci_mod_fc(req, &fib, &status);
>>   	if (cc == 3 || (cc == 1 && status == 24))
>>   		/* Function already gone or IRQs already deregistered. */
> 
> Looks good with or without using an initializer:
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> 
> 
