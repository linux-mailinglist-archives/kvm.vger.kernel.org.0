Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB67863F59A
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 17:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiLAQrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 11:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiLAQqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 11:46:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725E8BD893
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 08:46:42 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1FfsDN020900
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 16:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZMcxQ9w7ZhIS0g7L2T7kOqJ65WhwkFg6yh6E5uKVcWM=;
 b=NJoulmqHnKJW7sWWk3TZvymgzYiU7JwTpmphrUlL9q7687ULKT5SoRVtSbq/Jc1BLzFO
 HnN43GWDJ28HDTJXNF+AMplbTadJjsyHv0/PK0efWpDPe524EAzp614h1GmzSylsoiHQ
 TEwPNug43NHXBqUPVC+cpS/lKTi/ykcHq8MTvSaTLk9rCpX6tmX8h6WvAoOEceWH86Xx
 IiAzATovlGuqo+fGF83DL6dZpx2NqoGm+ue4+NGjv7X8y5rBZloHPwJvM+FoKrotCmbL
 zDPjgnI+VbkthkUQlXcLptzvm3BNaTFZAa7/yHoUzS7aRJSeEm15TcTJ3I295e94sTMw wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6y4u9tb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 16:46:42 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B1Ga7s4025272
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 16:46:41 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6y4u9tac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 16:46:41 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1Ge3DP011534;
        Thu, 1 Dec 2022 16:46:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3m3a2hwjgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 16:46:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B1GkajX10158818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 16:46:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 073BE5204E;
        Thu,  1 Dec 2022 16:46:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BB1CC5204F;
        Thu,  1 Dec 2022 16:46:35 +0000 (GMT)
Date:   Thu, 1 Dec 2022 17:46:34 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for
 skey-related functions
Message-ID: <20221201174634.57a1a44a@p-imbrenda>
In-Reply-To: <166991014258.186408.12012997417078839512@t14-nrb.local>
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
        <20221201084642.3747014-2-nrb@linux.ibm.com>
        <20221201141650.32cfe787@p-imbrenda>
        <166991014258.186408.12012997417078839512@t14-nrb.local>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yxgTYm-aW_z42FQ2HJvHPkYJ-48RU73I
X-Proofpoint-ORIG-GUID: 7Y_np2FHJU7uImy39hlRktU40UOc-twG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_12,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 01 Dec 2022 16:55:42 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2022-12-01 14:16:50)
> > On Thu,  1 Dec 2022 09:46:40 +0100
> > Nico Boehr <nrb@linux.ibm.com> wrote:  
> [...]
> > > diff --git a/lib/s390x/skey.c b/lib/s390x/skey.c
> > > new file mode 100644
> > > index 000000000000..100f0949a244  
> [...]
> > > +/*
> > > + * Set storage keys on pagebuf.  

... according to a pattern

> > 
> > surely you should explain better what the function does (e.g. how are
> > you setting the keys and why)  
> 
> Well there is the comment below which explains why the * 2 is needed, so what
> about this paragraph (after merging the commits as discussed before):
> 
>     * Each page's storage key is generated by taking the page's index in pagebuf,
>     * XOR-ing that with the given seed and then multipling the result with two.

looks good

> 
> (But really that's also easy to see from the code below, so I am not sure if
> this really adds value.)

if you want to add documentation, do it properly, otherwise there is no
point in having documentation at all :)

> 
> > > + * pagebuf must point to page_count consecutive pages.
> > > + */
> > > +void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)  
> > 
> > this name does not make clear what the function is doing. at first one
> > would think that it sets the same key for all pages.
> > 
> > maybe something like set_storage_keys_test_pattern or
> > skey_set_test_pattern or something like that  
> 
> Oh that's a nice suggestion, thanks.
> 
> >   
> > > +{
> > > +     unsigned char key_to_set;
> > > +     unsigned long i;
> > > +
> > > +     for (i = 0; i < page_count; i++) {
> > > +             /*
> > > +              * Storage keys are 7 bit, lowest bit is always returned as zero
> > > +              * by iske.
> > > +              * This loop will set all 7 bits which means we set fetch
> > > +              * protection as well as reference and change indication for
> > > +              * some keys.
> > > +              */
> > > +             key_to_set = i * 2;
> > > +             set_storage_key(pagebuf + i * PAGE_SIZE, key_to_set, 1);  
> > 
> > why not just i * 2 instead of using key_to_set ?  
> 
> Well you answered that yourself :)
> 
> In patch 2, the key_to_set expression becomes a bit more complex, so the extra
> variable makes sense to me.

fair enough
