Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106654694C7
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 12:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242200AbhLFLNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 06:13:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236157AbhLFLN2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 06:13:28 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6AqQla011803;
        Mon, 6 Dec 2021 11:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=upx2NMApNjcYQ1ik3dnYXVDiwrxpQkOBfXZHbJp6zsY=;
 b=DM5+uQHn1AbFIXeHhe7QpkRqMSxLCIEpJ2YBLDnx4DkDu2zryBpkkMk0LGIjvfFjZ9yp
 feD5r0onqxt/vylFqy2vhnDMo6SLlLdGVxaXFfPmwaVUgB2yhvESmm6/VGE06sYEQ9MP
 CFvVzegzYaALNjrFb8Y4NxJpsARmbY0kAGGFPJ9UvpYD9xPnwgw1EOHWgJl+zABeBdno
 xUNxklx+AxiTxeIfpTJBe8mHjqhhVfS1A9fmVpkAjzYAEj2oC1MxW51PdlbFbxxk9x3I
 1W5fvcoloz2d86/oNXBVewYxxnSN+qEzvQZHP49dkviJenUkW3jWiGcTw9X5kUm2EtDx xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3csb0c709u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Dec 2021 11:09:58 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B6B5Vso030157;
        Mon, 6 Dec 2021 11:09:58 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3csb0c7090-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Dec 2021 11:09:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B6B7ptV017867;
        Mon, 6 Dec 2021 11:09:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3cqyy92trv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Dec 2021 11:09:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B6B9qR020644220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Dec 2021 11:09:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C183A40A5;
        Mon,  6 Dec 2021 11:09:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5B9EA40A1;
        Mon,  6 Dec 2021 11:09:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.173])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Dec 2021 11:09:51 +0000 (GMT)
Date:   Mon, 6 Dec 2021 12:09:49 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: firq: floating interrupt
 test
Message-ID: <20211206120949.706b6dc0@p-imbrenda>
In-Reply-To: <959de529-503e-6dbf-b4ea-67e13252a86a@redhat.com>
References: <20211202123553.96412-1-david@redhat.com>
        <20211202123553.96412-3-david@redhat.com>
        <11f0ff2f-2bae-0f1b-753f-b0e9dc24b345@redhat.com>
        <20211203121819.145696b0@p-imbrenda>
        <fa95d6e6-27be-7abf-7b1e-bb6bb9d62214@redhat.com>
        <babd1100-844b-e00c-3e5b-30f7bca65636@redhat.com>
        <959de529-503e-6dbf-b4ea-67e13252a86a@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lDV8U3djrwxUnn4JuV9kw-wXf1BF6V9d
X-Proofpoint-GUID: 7ykq6HGEzqN6PBvkoIy6Z9vEngzyQvBE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-06_04,2021-12-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 Dec 2021 09:15:00 +0100
David Hildenbrand <david@redhat.com> wrote:

> >>>  
> >>>>  
> >>>>> +
> >>>>> +	/*
> >>>>> +	 * We want CPU #2 to be stopped. This should be the case at this
> >>>>> +	 * point, however, we want to sense if it even exists as well.
> >>>>> +	 */
> >>>>> +	ret = smp_cpu_stop(2);
> >>>>> +	if (ret) {
> >>>>> +		report_skip("CPU #2 not found");  
> >>>>
> >>>> Since you already queried for the availablity of at least 3 CPUs above, I
> >>>> think you could turn this into a report_fail() instead?  
> >>>
> >>> either that or an assert, but again, no strong opinions
> >>>  
> >>
> >> Just because there are >= 3 CPUs doesn't imply that CPU #2 is around.  
> > 
> > Ok, fair point. But if #2 is not around, it means that the test has been run 
> > in the wrong way by the user... I wonder what's better in that case - to 
> > skip this test or to go out with a bang. Skipping the test has the advantage 
> > of looking a little bit more "polite", but it has the disadvantage that it 
> > might get lost in automation, e.g. if somebody enabled the test in their CI, 
> > but did something wrong in the settings, they might not notice that the test 
> > is not run at all...  
> 
> I sticked to what we have in s390x/smp.c, where we fail if we only have
> a single CPU.
> 
> But I don't particularly care (and have to move on doing other stuff),
> so I'll do whatever maintainers want and resend :)
> 

a better solution for number != ID is needed (aka: I'll try to fix
it when I have the time), for now it works, so leave it as it is.
