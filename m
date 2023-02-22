Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9F869F937
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 17:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjBVQnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 11:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjBVQnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 11:43:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF133977E;
        Wed, 22 Feb 2023 08:43:03 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MFgY6Q000752;
        Wed, 22 Feb 2023 16:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Pr5N/dHKvbOGWfAeujYiCiMrJ1PQFec6SELfe9xkMnI=;
 b=tT0tXq9E9ClnV8ZHC8RumPGyhCSJy/eRc2I24uHyB8wbkqmEwLE/f79TgiSl1PyuyfzY
 vrUH3ZfB7851IDtfCM2T/LerAScaukjLbcjjSoA3YIQ3A8sM5/W1wG8k2KErkNONzc/X
 6KpnROs1gb5c2CFmL6htT3lehnuHRVTN5jXuO8ErbM057uGz7jy7xFMHgwsA1ERYAvC/
 Tb+yPXsGPI2WOlvSww+9S9ht++2bskjKUrRMTrueuUEgRdpBJp4eezXAY+1GpwFBAflQ
 8pDDE+6kidfaugI0IzrdG9zXSPbhQCJ5t7e+Fhv5C0JxUgxt3CWjM734LsxtRE6f82qR MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwnwysm0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 16:43:03 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31MGelYO015248;
        Wed, 22 Feb 2023 16:43:02 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwnwyskyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 16:43:02 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31MFv1EK007338;
        Wed, 22 Feb 2023 16:43:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6dm2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 16:43:00 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MGguTd27853306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 16:42:56 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC10B20043;
        Wed, 22 Feb 2023 16:42:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8B2720040;
        Wed, 22 Feb 2023 16:42:55 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.171.70.162])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 22 Feb 2023 16:42:55 +0000 (GMT)
Date:   Wed, 22 Feb 2023 17:42:53 +0100
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, mjrosato@linux.ibm.com,
        farman@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] KVM: s390: pci: fix virtual-physical confusion on
 module unload/load
Message-ID: <Y/ZGDfCAdLtArVL/@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20230222155503.43399-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222155503.43399-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uUodFcLzrGtyOpo24bZEFOeNwRGWrczc
X-Proofpoint-GUID: 5TZR_gowIUWzMD3wBtGFhBqUJTPLxCSV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_06,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220145
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023 at 04:55:02PM +0100, Nico Boehr wrote:
> @@ -112,7 +112,7 @@ static int zpci_reset_aipb(u8 nisc)
>  		return -EINVAL;
>  
>  	aift->sbv = zpci_aif_sbv;
> -	aift->gait = (struct zpci_gaite *)zpci_aipb->aipb.gait;
> +	aift->gait = phys_to_virt(zpci_aipb->aipb.gait);
>  
>  	return 0;
>  }

With this change aift->gait would never be NULL. Does it work with line 125?

120 int kvm_s390_pci_aen_init(u8 nisc)
121 {
122         int rc = 0;
123 
124         /* If already enabled for AEN, bail out now */
125         if (aift->gait || aift->sbv)
126                 return -EPERM;

