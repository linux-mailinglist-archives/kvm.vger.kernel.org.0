Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA54952A0C0
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345486AbiEQLxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiEQLxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:53:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DB830548;
        Tue, 17 May 2022 04:53:15 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBCL56006277;
        Tue, 17 May 2022 11:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=t8hio9eTv2fQpIJu3aN3/8ti3K3lhqMN+IzLi/3hqkM=;
 b=FdZfIpCeWlkr6G9hDwx37BmAPqzstr/keDERiU/MOQs2b78TJufZ/3ZCSvZov5l33RFi
 7lyF/0pwPC3Olg6vkFUGujMazIJY0NeMWOqFpK35Tn9hvXlKjfP89aOPI5zUikXM008K
 zF0/+ZXXGa9f1UvoWdjJ2rwTXOSOVYaXwRZODL3KJ0Sm0axMT0SpScTR2wAcerJ4d2Vq
 ZqQYGPEwbqphMVpX+/Qmxm+Mw82N4f6W/F7d4ixtb5K9nAX4agLx+bJg6fWyns5bpEB2
 J9DkAs46V0j30RSc/n61hXieUqH6HSiZlVe80LCUl+WzJWYKcymdAmHu+6sKcvoEV827 Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4amegsag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:53:15 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBrEVL017607;
        Tue, 17 May 2022 11:53:14 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4amegsa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:53:14 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBqNk3003133;
        Tue, 17 May 2022 11:53:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3g2428kb08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:53:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBr9um48628100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:53:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 347024C046;
        Tue, 17 May 2022 11:53:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D06EC4C040;
        Tue, 17 May 2022 11:53:08 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.55.58])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:53:08 +0000 (GMT)
Message-ID: <f33a8ff36cda37295d3347289c0a3bd837d633ba.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add migration test for
 storage keys
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Tue, 17 May 2022 13:53:08 +0200
In-Reply-To: <bceaae6a24324cdb72056977fd6bf7916adcc9d7.camel@linux.ibm.com>
References: <20220516090702.1939253-1-nrb@linux.ibm.com>
         <20220516090702.1939253-2-nrb@linux.ibm.com>
         <947af627-64e0-486d-18e2-c877bc4c4ba6@linux.ibm.com>
         <3ab95d5d553362a686b9526c8b53996dcaf20400.camel@linux.ibm.com>
         <bceaae6a24324cdb72056977fd6bf7916adcc9d7.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CnG9Wli1enauAXtH1ao7yp8FYLA8GGzB
X-Proofpoint-ORIG-GUID: PMF41UQNHvU3lMvkMaQf4IaaDsVmqYkk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=933
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-17 at 13:44 +0200, Janis Schoetterl-Glausch wrote:
> No I think you're right, although in practice the reference bits
> should
> match. Or did you observe a mismatch?

Yes, I can sometimes observe mismatches.
