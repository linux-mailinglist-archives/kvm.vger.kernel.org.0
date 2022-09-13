Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813CD5B6D65
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 14:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiIMMhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 08:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiIMMhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 08:37:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DCE13D4E
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 05:37:00 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28DBOOP2029699
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 12:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=01IxH5mYHuGsvLSkhCsc975Sf4wlOXrktVoxuZVUW8k=;
 b=UJIUu5c9tB4CkXD6TfhMvL1zLz5CJryHFi3Zbrzd2jRq0vTaGrN2yOpRFxdWwEbHeQP+
 6xKGgqvKNcX61M9+o7Vl5qkGyLk1nPdgHByDgl5WfLWgdzvFGE4d2dtSj7tUzHWgRfQj
 LXGHfbnK9PADUagf7U7snEisYuZOkr/kxmSfaOT4Rh91lpIHSpwiDLfPxNvG/JSleu63
 y7stRpLIALGEiJrQszDUffQrKT/mkcLO0xnaxYtV76VyP48AzmnA5sUzYInXvk3kT3cU
 Nu+SXVCvg5185reQm3Ein73gBZ15Qxrc2CIHtbLdje28eCkE86aHviAi/a56ThZB5kBp wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjry8tawp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 12:36:59 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28DC6i3m008745
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 12:36:59 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjry8tavw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 12:36:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28DCagrZ023016;
        Tue, 13 Sep 2022 12:36:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3jghujbtgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 12:36:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28DCasZr37552510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 12:36:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EF074203F;
        Tue, 13 Sep 2022 12:36:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35AFC42041;
        Tue, 13 Sep 2022 12:36:54 +0000 (GMT)
Received: from [9.171.5.112] (unknown [9.171.5.112])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Sep 2022 12:36:54 +0000 (GMT)
Message-ID: <362a2790-87dc-d2ce-b080-c801ec131273@linux.ibm.com>
Date:   Tue, 13 Sep 2022 14:36:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: create persistent comm-key
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220909121453.202548-1-nrb@linux.ibm.com>
 <20220909121453.202548-3-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220909121453.202548-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KGTQTponSwJY4xM_YdR4mSNajQhm8obU
X-Proofpoint-GUID: RW6cSh35iieUaaKzc-_cnP3j0S31Q_Cv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_05,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1015
 phishscore=0 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209130057
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/9/22 14:14, Nico Boehr wrote:
> To decrypt the dump of a PV guest, the comm-key (CCK) is required. Until
> now, no comm-key was provided to genprotimg, therefore decrypting the
> dump of a kvm-unit-test under PV was not possible.
> 
> This patch makes sure that we create a random CCK if there's no
> $(TEST_DIR)/comm.key file.
> 
> Also allow dumping of PV tests by passing the appropriate PCF to
> genprotimg (bit 34). --x-pcf is used to be compatible with older
> genprotimg versions, which don't support --enable-dump. 0xe0 is the
> default PCF value and only bit 34 is added.
> 
> Unfortunately, recent versions of genprotimg removed the --x-comm-key
> argument which was used by older versions to specify the CCK. To support
> these versions, we need to parse the genprotimg help output and decide
> which argument to use.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
