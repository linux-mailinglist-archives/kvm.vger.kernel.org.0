Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175351BC6E5
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 19:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgD1RjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 13:39:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40126 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbgD1RjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 13:39:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SHXK5o152486;
        Tue, 28 Apr 2020 17:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7i1ESjs+4EOIwOHpXNKlv8+yLVojjVE6qQe15gnCMhE=;
 b=wrXLT3hzumLcnAGcuf5z1Y7OuJMZ/2LxMkSZZKtnJvqzgsDPEvlrX+/2CX55JSGR1aAJ
 5G0DJh2aCIFcnmM2Vycx37cSue1o3AMwTGoaq+VFy5Fng1KqMuZ01c9QLHQi9/ULYRXo
 tUtTE9nPTHMXVGVaDcq9hUKiOvcIxJ59GnEZawxyllyCSGq72xqZ5B6S6V/oehdCSFa7
 e2fdecyKt/yz2bhzuSeiCCaZZ9DDBI/ATGJMaX6s4jn23LaPCg5lLzWmfXfxy3Sdi3Py
 mPSUI8+P4BFhRlThO+SZSdgnIB4O0IwoUv4RYgg8ryZYvsNC1vSBDERULXO2VocY9M/O Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30p01nqy1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 17:39:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SHcmU9077221;
        Tue, 28 Apr 2020 17:39:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30mxpgj9k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 17:39:04 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SHd3Jt005867;
        Tue, 28 Apr 2020 17:39:03 GMT
Received: from localhost.localdomain (/10.159.150.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 10:39:03 -0700
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest"
 VM-execution control in vmcs02 if vmcs12 doesn't set it
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com>
 <20200415193016.GF30627@linux.intel.com>
 <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
 <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com>
 <d49ce960-92f9-85eb-4cfb-d533a956223e@oracle.com>
 <20200418015545.GB15609@linux.intel.com>
 <c37b9429-0cb8-6514-44a7-65544873dba0@redhat.com>
 <02a49d40-fe80-2715-d9a8-17770e72c7a3@oracle.com>
 <11ce961c-d98c-3c4c-06a7-3c0f8336a340@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a5bf92bd-d4df-8d6c-8df2-9c993b31459a@oracle.com>
Date:   Tue, 28 Apr 2020 10:38:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <11ce961c-d98c-3c4c-06a7-3c0f8336a340@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/28/20 1:14 AM, Paolo Bonzini wrote:
> On 28/04/20 09:25, Krish Sadhukhan wrote:
>>> Absolutely.  Unrestricted guest requires EPT, but EPT is invisible to
>>> the guest.  (Currently EPT requires guest MAXPHYADDR = host MAXPHYADDR,
>>> in the sense that the guest can detect that the host is lying about
>>> MAXPHYADDR; but that is really a bug that I hope will be fixed in 5.8,
>>> relaxing the requirement to guest MAXPHYADDR <= host PHYADDR).
>> Should EPT for the nested guest be set up in the normal way (PML4E ->
>> PDPTE-> PDE -> PTE) when GUEST_CR0.PE is zero ? Or does it have to be a
>> special set up like only the PTEs are needed because no protection and
>> no paging are used ?
> I don't understand.  When EPT is in use, the vmcs02 CR3 is simply set to
> the vmcs12 CR3.


Sorry, I should have framed my question in a better way.

My question is  how should L1 in the test code set up EPTP for L2 when 
L2 is an unrestricted guest with no protection (GUEST_CR0.PE = 0) and no 
paging (GUEST_CR0.PG = 0) ? Should EPTP in test code be set up in the 
same way as when L2 is an unrestricted guest with protection and paging 
enabled ?

Getting confused by legacy 16-bit Real Mode and an unrestricted guest in 
Real Mode. :-)
> Paolo
>
