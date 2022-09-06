Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223345AEFEF
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 18:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238945AbiIFQIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 12:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiIFQHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 12:07:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC9E9A69E
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 08:31:33 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286FBlmo028588
        for <kvm@vger.kernel.org>; Tue, 6 Sep 2022 15:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=SEQjtyC/iLrjycHTLrmQ9IGv2qPqHNKn9LTJxhoJ5qQ=;
 b=Zk4I0OgYD5HI4SR/g5aZjcpwwTqjRkoLoV14ZAJLgjqH/C+BEObp84qtwHjpo9/RRAG4
 pZxYUmOYB3XCiN6dNH01kThr2axIe/HlUsu3mD9Y2TXHoI8YfxnJe2+iUho/eztE9ftl
 GGgFyqc+pPjcoGvpL+OAEH+VkdRWxdsN8Rfphm7tBkwaHDI7tnlgdfgrEfHsLZ9Iik5a
 bRIzIF49JD0o8HPUvzyTDdgMVfzslxgeFqQT+XjzFwX7LNfcVwaTH3GuketHDyA7qtXo
 mDHblnJzZx59WBg+xPkZMGfULI+PDUE/IqaiwLX6Gx5AJkpSH0UEC4FCDcCFpoCHH2Ph dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3je8ms8sxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 15:31:32 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 286FBpTJ028829
        for <kvm@vger.kernel.org>; Tue, 6 Sep 2022 15:31:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3je8ms8swh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 15:31:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 286FM1Hs010090;
        Tue, 6 Sep 2022 15:31:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3jbxj8twr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 15:31:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 286FRwtS40239454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Sep 2022 15:27:58 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C984A4060;
        Tue,  6 Sep 2022 15:31:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2186AA405C;
        Tue,  6 Sep 2022 15:31:27 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.61.54])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Sep 2022 15:31:27 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <d12c0927-fa06-4f27-606e-25971d11e2aa@linux.ibm.com>
References: <20220825131600.115920-1-nrb@linux.ibm.com> <20220825131600.115920-3-nrb@linux.ibm.com> <d12c0927-fa06-4f27-606e-25971d11e2aa@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: create persistent comm-key
Message-ID: <166247828688.90129.7620152734606584325@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 06 Sep 2022 17:31:26 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CVxHAuuCKW5tZTmcIea8GO5K5I5YwNGM
X-Proofpoint-ORIG-GUID: UrTf3EcV7bYg40YApySZ8YX8npUDO_64
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_07,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209060072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-09-06 11:50:46)
> Hmmmmmmm(TM)
>=20
> My first thought was that I'd be pretty angry if the CCK changes on a=20
> distclean. But the only scenario where this would matter is when the=20
> tests are provided to another system.
>=20
> I'm still a bit torn about deleting the CCK especially as there will=20
> always be a CCK in the SE header no matter if we specify one or not.

I really don't have a strong opinion about this. I think it makes sense to =
clean
up stuff a Makefile has left behind. But I am honestly just as fine with
removing this.
