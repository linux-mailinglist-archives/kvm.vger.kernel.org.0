Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B971520FB
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 20:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgBDTZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 14:25:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53812 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbgBDTZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 14:25:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014JNPJc076640;
        Tue, 4 Feb 2020 19:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=E7izVF8VHlOuaprUDzyes2uRr9PaxAogt9I1VIGvP50=;
 b=PssQbLXoxhz7QRcrzseSJMDq79/3pQpl0sS5Pa1f8B8ovJl3YBEwxy2KmtaIL6oxEiEs
 MJRxYiQnbVCNMxk9cD0TMBoOoE/dye+2NVnkiHpiL8O4kJfdIeCVdSowVB6UUAMxI9No
 zBjJH5pRgBRM+Aw/saxMEEQV4dQ55pAb8W5zpFY3QancPdrzuqWEOFg1rL6VMpXfjEUI
 bHEtHwdNQRNcly/U2V88aw4XzU0ERNJD8JrPsD3B9UCm2Z/SOu38POxlqPVSdn6SSiwn
 9dkeR8ZeS1ApgWjvudwpD8zvGn/f+Qnr56we5+hsjXWSn4EW1RwLymng0Gj5qVOY0Srx BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xw0ru8xvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 19:24:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014JOJAe010226;
        Tue, 4 Feb 2020 19:24:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xxvusfhs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 19:24:48 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 014JOjqi016183;
        Tue, 4 Feb 2020 19:24:46 GMT
Received: from [10.175.207.61] (/10.175.207.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 11:24:45 -0800
Subject: Re: [PATCH RFC 10/10] nvdimm/e820: add multiple namespaces support
To:     Barret Rhoden <brho@google.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <20200110190313.17144-11-joao.m.martins@oracle.com>
 <e605fed8-46f5-6a07-11e6-2cc079a1159b@google.com>
 <CAPcyv4iiSsEOsfEwLQcV3bNDjBSxw1OgWoBdEWPQEymq6=xm-A@mail.gmail.com>
 <ae788015-616f-96e6-3a0e-39c1911c4b01@google.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <6fc0d900-3df7-d09a-9b6a-dc6a82823d94@oracle.com>
Date:   Tue, 4 Feb 2020 19:24:39 +0000
MIME-Version: 1.0
In-Reply-To: <ae788015-616f-96e6-3a0e-39c1911c4b01@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002040130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002040130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/20 6:20 PM, Barret Rhoden wrote:
> Hi -
> 
> On 2/4/20 11:44 AM, Dan Williams wrote:
>> On Tue, Feb 4, 2020 at 7:30 AM Barret Rhoden <brho@google.com> wrote:
>>>
>>> Hi -
>>>
>>> On 1/10/20 2:03 PM, Joao Martins wrote:
>>>> User can define regions with 'memmap=size!offset' which in turn
>>>> creates PMEM legacy devices. But because it is a label-less
>>>> NVDIMM device we only have one namespace for the whole device.
>>>>
>>>> Add support for multiple namespaces by adding ndctl control
>>>> support, and exposing a minimal set of features:
>>>> (ND_CMD_GET_CONFIG_SIZE, ND_CMD_GET_CONFIG_DATA,
>>>> ND_CMD_SET_CONFIG_DATA) alongside NDD_ALIASING because we can
>>>> store labels.
>>>
>>> FWIW, I like this a lot.  If we move away from using memmap in favor of
>>> efi_fake_mem, ideally we'd have the same support for full-fledged
>>> pmem/dax regions and namespaces that this patch brings.
>>
>> No, efi_fake_mem only supports creating dax-regions. What's the use
>> case that can't be satisfied by just specifying multiple memmap=
>> ranges?
> 
> I'd like to be able to create and destroy dax regions on the fly.  In 
> particular, I want to run guest VMs using the dax files for guest 
> memory, but I don't know at boot time how many VMs I'll have, or what 
> their sizes are.  Ideally, I'd have separate files for each VM, instead 
> of a single /dev/dax.
> 
> I currently do this with fs-dax with one big memmap region (ext4 on 
> /dev/pmem0), and I use the file system to handle the 
> creation/destruction/resizing and metadata management.  But since fs-dax 
> won't work with device pass-through, I started looking at dev-dax, with 
> the expectation that I'd need some software to manage the memory (i.e. 
> allocation).  That led me to ndctl, which seems to need namespace labels 
> to have the level of control I was looking for.
> 

Indeed this is the intent of the patch.

As Barret mentioned, memmap= is limited to the one namespace covering the entire
region, and this would fix it (regardless of namespace mode). Otherwise we gotta
know in advance the amount of guests and its exact sizes, which would be
somewhat unflexible.

But given that it's 'pmem emulation' I thought it was OK to twist the label-less
aspect of nd_e820 (unless there's hardware out there which does this?).

If Dan agrees, I can continue with the patch.
