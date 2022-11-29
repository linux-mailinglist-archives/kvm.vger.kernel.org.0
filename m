Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4048063BE39
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 11:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiK2Kqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 05:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiK2Kqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 05:46:36 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992226036D
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 02:46:35 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATAWeLU035774
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 10:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wK+tXcnXfF/3D0WdbMqXCRpKVQKNLfJhPvBBq++VnfM=;
 b=lPQODVBvmJjtTZjbj7ESRIfvtwBC4ml+M3QORbO1a4MqvN4a6nBOwWNBA4ag8+wk1d4m
 BcuhM18P+JupfZX10twEhZ/fi7GH2buHF6XIOmPEOPkQCL+2qN89kZaFIkE1DKsl1w21
 YmUH+ZfdOokGD8Vw1EWRtukO8wRjJOY7J7twVLYUdmfroZJyC+hus828dpMGaoz0JmcG
 Z3jDdtxgDO72Bhax1B2aDm+il2HvyL0yf+kAa2RZIkf0WTnylgYFcy3L/xq9t6VzBH5n
 CFwdzf3u/hHR80J/8TM8R14Xibmaa7P3AejQMRLg4mDRWwVyFAhI4+vU1QLJyuK6pqiu kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5ge18ak0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 10:46:34 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ATAaO98010266
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 10:46:34 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5ge18ajh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 10:46:34 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ATAa3eM027717;
        Tue, 29 Nov 2022 10:46:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3m3ae92tc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 10:46:32 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ATAkSma61800778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 10:46:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C78E442045;
        Tue, 29 Nov 2022 10:46:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6191E4203F;
        Tue, 29 Nov 2022 10:46:28 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.61.66])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 10:46:28 +0000 (GMT)
Message-ID: <19b55514544e567febc49d76091776c9b8fca056.camel@linux.ibm.com>
Subject: Re: [PATCH v2 2/2] s390x: use the new PSW and PSW_CUR_MASK macros
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        thuth@redhat.com
Date:   Tue, 29 Nov 2022 11:46:28 +0100
In-Reply-To: <20221129094142.10141-3-imbrenda@linux.ibm.com>
References: <20221129094142.10141-1-imbrenda@linux.ibm.com>
         <20221129094142.10141-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -ax4UWS6l2ZiimMetnZ25gQMCFURLFha
X-Proofpoint-ORIG-GUID: bxNMRk0I_5c6jsEecJzVz-sBWvUhXx2K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_07,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=548 clxscore=1015 phishscore=0 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-11-29 at 10:41 +0100, Claudio Imbrenda wrote:
> Use the new macros in the existing code. No functional changes intended.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>


[...]
