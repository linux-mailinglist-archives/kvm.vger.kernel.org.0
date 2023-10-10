Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC2D7BFA29
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 13:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjJJLqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 07:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjJJLqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 07:46:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A82CA9
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 04:46:36 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39ABjObu009919
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 11:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=XR38XXyln3LqOwJPbjSF+wE2yZfn5V3hGhlfdU0E6FU=;
 b=YQG3Ml/dHwVzi9KRH/9koUOwffrPUbVkHyGom3588yVeSZKL9RCdnlaCP7EUzUtkJopf
 glTmW755tqxORv3sBYdOoBykXxxWK07n+QSzmUxW5uNRD/LnxmxTUTHMY+lmpxqP7nGV
 GHMb0CLGn/DCwML+qDmCyt8MyUNd2voD7Pv6welY9G6GsAZuTSyk6VahJNJm+gxIF8rC
 7U2yiUExAFC8m0s3elSOU5FUVeG6F/qbUyEvQPGeU4XQq812bAUBRUG+mbMm8SU/D0B3
 yBaJMbVrQoovPq/9u3Ad5wQbmppgyLYFCoATpsVRdXMJ411Z46nfpWIgh0SYAI+Mes+d hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn6110167-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 11:46:35 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ABjcdO011122
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 11:46:34 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn611014c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 11:46:34 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8nCcV001146;
        Tue, 10 Oct 2023 11:42:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkkvjqmat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 11:42:35 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39ABgWW69634528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 11:42:32 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C2A62004B;
        Tue, 10 Oct 2023 11:42:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FE0420049;
        Tue, 10 Oct 2023 11:42:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 11:42:32 +0000 (GMT)
Date:   Tue, 10 Oct 2023 13:42:30 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/3] lib: s390x: hw: Provide early detect
 host
Message-ID: <20231010134230.0d7a0156@p-imbrenda>
In-Reply-To: <95f2e807-6b7f-4e24-a018-a041a2f7ce00@linux.ibm.com>
References: <20231010073855.26319-1-frankja@linux.ibm.com>
        <20231010073855.26319-2-frankja@linux.ibm.com>
        <20231010124029.70abcb0a@p-imbrenda>
        <95f2e807-6b7f-4e24-a018-a041a2f7ce00@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _GbqoAYQFKLBXdhk8_sAlYH_WwmMK67J
X-Proofpoint-ORIG-GUID: 4I_nYlmTDY36EvZEKDU5OGcEGSAN54dg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_07,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Oct 2023 13:03:08 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 10/10/23 12:40, Claudio Imbrenda wrote:
> > On Tue, 10 Oct 2023 07:38:53 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> For early sclp printing it's necessary to know if we're under LPAR or
> >> not so we can apply compat SCLP ASCII transformations.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>   lib/s390x/hardware.c | 8 ++++++++
> >>   lib/s390x/hardware.h | 1 +
> >>   2 files changed, 9 insertions(+)
> >>
> >> diff --git a/lib/s390x/hardware.c b/lib/s390x/hardware.c
> >> index 2bcf9c4c..d5a752c0 100644
> >> --- a/lib/s390x/hardware.c
> >> +++ b/lib/s390x/hardware.c
> >> @@ -52,6 +52,14 @@ static enum s390_host do_detect_host(void *buf)
> >>   	return HOST_IS_UNKNOWN;
> >>   }
> >>   
> >> +enum s390_host detect_host_early(void)
> >> +{
> >> +	if (stsi_get_fc() == 2)
> >> +		return HOST_IS_LPAR;
> >> +
> >> +	return HOST_IS_UNKNOWN;
> >> +}
> >> +
> >>   enum s390_host detect_host(void)
> >>   {
> >>   	static enum s390_host host = HOST_IS_UNKNOWN;
> >> diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
> >> index 86fe873c..5e5a9d90 100644
> >> --- a/lib/s390x/hardware.h
> >> +++ b/lib/s390x/hardware.h
> >> @@ -24,6 +24,7 @@ enum s390_host {
> >>   };
> >>   
> >>   enum s390_host detect_host(void);
> >> +enum s390_host detect_host_early(void);  
> > 
> > I wonder if it weren't easier to fix detect_host so it can be used
> > early....
> >   
> 
> Problem is, where do you start and where do you end?
> 
> We could statically allocate a page but why did we add the current 
> version then? (The old version did that if I remember correctly).

the old version also allocated pages, and was a hodgepodge of various
functions replicating the same behaviour, many calling the others. the
main goal of the current version was to make it more readable and
maintainable. 

a possible fix could also involve allocating the buffer on the stack of
do_detect_host(), so it's not taking up memory permanently.

that said, I don't have a strong opinion about this, but maybe it's a
good idea to not replicate the same behaviour again :)

if you don't want to fix detect_host(), then maybe something like this
instead?

diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
index 86fe873c..5e5a9d90 100644
--- a/lib/s390x/hardware.h
+++ b/lib/s390x/hardware.h
@@ -24,6 +24,7 @@ enum s390_host {
 };
 
 enum s390_host detect_host(void);
+enum s390_host detect_host_early(void);
 
 static inline uint16_t get_machine_id(void)
 {
diff --git a/lib/s390x/hardware.c b/lib/s390x/hardware.c
index 2bcf9c4c..b281cf10 100644
--- a/lib/s390x/hardware.c
+++ b/lib/s390x/hardware.c
@@ -28,7 +28,7 @@ static enum s390_host do_detect_host(void *buf)
        if (stsi_get_fc() == 2)
                return HOST_IS_LPAR;
 
-       if (stsi_get_fc() != 3)
+       if (!buf || stsi_get_fc() != 3)
                return HOST_IS_UNKNOWN;
 
        if (!stsi(buf, 1, 1, 1)) {
@@ -67,3 +67,8 @@ enum s390_host detect_host(void)
        initialized = true;
        return host;
 }
+
+enum s390_host detect_host_early(void)
+{
+       return do_detect_host(NULL);
+}
