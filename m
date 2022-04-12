Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14984FE036
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351049AbiDLMdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353079AbiDLMcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:32:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41C95047E;
        Tue, 12 Apr 2022 04:49:28 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CANggt021961;
        Tue, 12 Apr 2022 11:49:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=O6kmF+eOEXju5wrfcMB4xra7K/FweXtQPUMITdLTa6I=;
 b=KlcC3EyO3z5e1IbK+5xIqbZ9kOoZs0ingsEanYrbiKbYbg9G9xA5v0cdKk6XUnV+0SXm
 g59zpSpZ79pbKLB3NGpOxvWbOX1RRGbtXrRnwJRd4U0BUUNlL85yx2bYUh+nBCpO/fd+
 ciWfAxNvrsRr2D1Rl3Nz1DPFRy4uLK2PNV+kt0rVEfdDwnHXoJq82Hdh+yFoXzYEkOFY
 wXNoTA6Ft6R1lbXU3hA57EY4jkhvKo1siG9BmUW9PCPIUnlANReKeccXNPIWHwXdTeI1
 oTxUjryKPLsDnS+0kNQ4DIrusYsl2Ud7slG6DsrM6MHQmEsJnrVpGrmptvfIc8eiGC7S FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd3sjq67q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 11:49:28 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CAnHn6011469;
        Tue, 12 Apr 2022 11:49:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd3sjq670-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 11:49:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CBbuZq007708;
        Tue, 12 Apr 2022 11:49:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fb1s8vtj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 11:49:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CBnVAM46793022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 11:49:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33434A405B;
        Tue, 12 Apr 2022 11:49:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F310DA4054;
        Tue, 12 Apr 2022 11:49:21 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.152.224.44])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 11:49:21 +0000 (GMT)
Message-ID: <627b95549636e5fb4bae5ba792298eee0a689b13.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add selftest for migration
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Date:   Tue, 12 Apr 2022 13:49:21 +0200
In-Reply-To: <20220411144944.690d19f5@p-imbrenda>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
         <20220411100750.2868587-5-nrb@linux.ibm.com>
         <20220411144944.690d19f5@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0iw_cbBaosQJmeiNxMv7ilYzntoLpbIi
X-Proofpoint-GUID: zFBB5AfllHyO_kJATp6dv6_4w1EPh6Zx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_03,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 mlxlogscore=797
 malwarescore=0 phishscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-04-11 at 14:49 +0200, Claudio Imbrenda wrote:
[...]
> > diff --git a/s390x/selftest-migration.c b/s390x/selftest-
> > migration.c
[...]
> > +int main(void)
> > +{
> > +       /* don't say migrate here otherwise we will migrate right
> > away */
> > +       report_prefix_push("selftest migration");
> > +
> > +       /* ask migrate_cmd to migrate (it listens for 'migrate') */
> > +       puts("Please migrate me\n");
> > +
> > +       /* wait for migration to finish, we will read a newline */
> > +       (void)getchar();
> 
> how hard would it be to actually check that you got the newline?

It would be simple. I decided for ignoring what we actually read
because that's what ARM and PPC do.

But I am also OK checking we really read a newline. What would you
suggest to do if we read something that's not a newline? Read again
until we actually do get a newline?
