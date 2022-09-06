Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA305AE27B
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 10:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiIFI2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 04:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbiIFI2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 04:28:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1184F6E8A4
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 01:28:11 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2868CmY6020304;
        Tue, 6 Sep 2022 08:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=X14S1t8iOyLE3wWBeBqZLQ9sLfznSv1wQi96oOHVnIw=;
 b=NGIu0MhK5UTdnlLbfacecHmXOTzn45PfJ/Hlr+67rsX6bCfV6s+kdcgySlgkPFGNrJqK
 +BXRQBd6HO827y1hPiYzWzV5TYSU4qnEFH75IoU2uW3bO9K0rXx7PVWpMJzXyZLqrlDx
 WEbueYdDss9lVxVYDcUTuw5I+0zklS+XpTmBOwVgnNIGcbPHx6K7KjscKNboJCitglh/
 xEWs+4/fMA5MGGkmWYmhpjJCzS7fyeptw4HEw+bKGsiD2o02P+l68lqrEU8pIoIiosrh
 AESMsjXOUWvPGbgMxivOJSn9Gco1Qyw2fzT4C4fZ+v7yUP6RU5haASV1/VK6VlJni7Cm 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3je2gc0gmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 08:27:52 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2868D2mr020981;
        Tue, 6 Sep 2022 08:27:52 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3je2gc0gkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 08:27:52 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2868Lxbk007595;
        Tue, 6 Sep 2022 08:27:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3jbxj8thx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 08:27:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2868RjLs39256392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Sep 2022 08:27:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CE6C11C04C;
        Tue,  6 Sep 2022 08:27:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E68D11C04A;
        Tue,  6 Sep 2022 08:27:45 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.15.101])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Sep 2022 08:27:45 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220902075531.188916-7-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com> <20220902075531.188916-7-pmorel@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [PATCH v9 06/10] s390x/cpu_topology: resetting the Topology-Change-Report
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Message-ID: <166245286528.5995.1915366030580373557@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 06 Sep 2022 10:27:45 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ekYQNY6kL4HH4emiPseFOAds7pVzGOnb
X-Proofpoint-ORIG-GUID: wksvxoRE0R37mCA3YQWUAyEAOF5hNGEq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_03,2022-09-05_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015
 mlxscore=0 mlxlogscore=872 impostorscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209060038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2022-09-02 09:55:27)
> During a subsystem reset the Topology-Change-Report is cleared
> by the machine.
> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
>  bit of the SCA in the case of a subsystem reset.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
