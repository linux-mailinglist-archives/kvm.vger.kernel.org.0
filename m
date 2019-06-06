Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B76BF37CBB
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 20:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfFFSwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 14:52:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49696 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbfFFSwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 14:52:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56Imwel149579;
        Thu, 6 Jun 2019 18:51:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=730DlizpPMBDP9JxaWPpPRW09tHdiXn9kT5XANcah2I=;
 b=k739h19WTHvvX2kUDtgH5cK/4SmGQoP0F6O2b7LmVCJzgJNm48MU9+dHLrEyHC0HMaaO
 Tj333O8KWgTGOBfoYirFbAkwzWwar5HkZQtqrs/dp8Nihdr7Dce0r9YXBaJ2iejS3QUb
 RQYrxRmF/zU/MnAOz0/RKJLFIn3euGg23QRWfsGR8c/4PtFvrK0+phfTXdhn3Y2iPMEP
 EDP9469GLrSLnUvIDYETs5SWlyQKLu7WOjJzvrb7iSa8438lT1qiANaDosjThhtTaNUK
 71bV90GmtWx3WChWCSTP6djtBksev+KU+WbPFomQ+LJUAsXNet8EilC2XXRnx2QFpIjC yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2suevdtk1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 18:51:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56Ioi2p069767;
        Thu, 6 Jun 2019 18:51:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2swnhcv15b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 18:51:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x56IpPQ6026659;
        Thu, 6 Jun 2019 18:51:26 GMT
Received: from [10.175.215.95] (/10.175.215.95)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 11:51:25 -0700
Subject: Re: [patch v2 3/3] cpuidle-haltpoll: disable host side polling when
 kvm virtualized
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.360289262@amt.cnet> <20190604122404.GA18979@amt.cnet>
 <cb11ef01-b579-1526-d585-0c815f2e1f6f@oracle.com>
 <20190606183632.GA20928@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <7f988399-7718-d4f4-f59c-792fbcbcf9b3@oracle.com>
Date:   Thu, 6 Jun 2019 19:51:21 +0100
MIME-Version: 1.0
In-Reply-To: <20190606183632.GA20928@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=818
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906060127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=867 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/19 7:36 PM, Andrea Arcangeli wrote:
> Hello,
> 
> On Thu, Jun 06, 2019 at 07:25:28PM +0100, Joao Martins wrote:
>> But I wonder whether we should fail to load cpuidle-haltpoll when host halt
>> polling can't be disabled[*]? That is to avoid polling in both host and guest
>> and *possibly* avoid chances for performance regressions when running on older
>> hypervisors?
> 
> I don't think it's necessary: that would force an upgrade of the host
> KVM version in order to use the guest haltpoll feature with an
> upgraded guest kernel that can use the guest haltpoll.
> 

Hence why I was suggesting a *guest* cpuidle-haltpoll module parameter to still
allow it to load or otherwise (or allow guest to pick).

> The guest haltpoll is self contained in the guest, so there's no
> reason to prevent that by design or to force upgrade of the KVM host
> version. It'd be more than enough to reload kvm.ko in the host with
> the host haltpoll set to zero with the module parameter already
> available, to achieve the same runtime without requiring a forced host
> upgrade.
> 
It's just with the new driver we unilaterally poll on both sides, just felt I
would point it out should this raise unattended performance side effects ;)

> The warning however sounds sensible.
> 

Cool.

	Joao
