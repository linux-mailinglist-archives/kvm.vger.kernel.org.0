Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75A92E288C
	for <lists+kvm@lfdr.de>; Thu, 24 Dec 2020 19:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgLXSUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Dec 2020 13:20:09 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46900 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbgLXSUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Dec 2020 13:20:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOIARHe056281;
        Thu, 24 Dec 2020 18:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qEmeGlCLCgt/Z7EOZTRz2LThDl5+xsNbseT1OQHDKc4=;
 b=UBq1e7oiXKhqNcj7TKiayz80HoUdoNJelFOpXNyBbcqBeAtNnsUiVKQV4kCI5p/TrHAO
 AorMauDniG021eUueODiGRoAeIIA15wXXXkjND4nwOWQSHO7sF67OYS6QhdneVj1DFVv
 CP934VZDJSC4iW/9U3NykrPKpknOns2wujFmJ123BSRuIfp04RdPz/Xp6bc49phfgyOd
 4eKJzHDAfSxPKfG7/YUns+zmsQziWZlXdqxNwmFfw6VPfwfnlSTJeAlCYq+fN4FjR7CQ
 fpzMHF5YtbogD5++HdO6LMnw3XgjoCW52V5WmePfuJInkitxZXiepM120ENKqvOR+Ti4 QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35k0d1ccq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Dec 2020 18:19:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOIA60t165035;
        Thu, 24 Dec 2020 18:19:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35k0ecbnqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Dec 2020 18:19:23 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BOIJMwQ012840;
        Thu, 24 Dec 2020 18:19:22 GMT
Received: from localhost.localdomain (/10.159.237.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Dec 2020 10:19:22 -0800
Subject: Re: [kvm-unit-tests PATCH v1 00/12] Fix and improve the page
 allocator
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <611f15e5-65e5-ba83-8082-7c978e1e186e@oracle.com>
Date:   Thu, 24 Dec 2020 10:19:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9845 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012240115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9845 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012240115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/16/20 12:11 PM, Claudio Imbrenda wrote:
> My previous patchseries was rushed and not polished enough. Furthermore it
> introduced some regressions.
>
> This patchseries fixes hopefully all the issues reported, and introduces
> some new features.
>
> It also simplifies the code and hopefully makes it more readable.
>
> Fixed:
> * allocated memory is now zeroed by default
>
> New features:
> * per-allocation flags to specify not just the area (like before) but also
>    other parameters
>    - zero flag: the allocation will be zeroed
>    - fresh flag: the returned memory has never been read or written to before
> * default flags: it's possible to specify which flags should be enabled
>    automatically at each allocation; by default the zero flag is set.
>
>
> I would appreciate if people could test these patches, especially on
> strange, unusual or exotic hardware (I tested only on s390x)
>
>
> GitLab:
>    https://urldefense.com/v3/__https://gitlab.com/imbrenda/kvm-unit-tests/-/tree/page_allocator_fixes__;!!GqivPVa7Brio!LehVoD4e6fUc92A7OE_Rxl2QwwkrW4aY0WHTmPkgKyxYviNfnTs3hEmYWHsMj3I9paC-$
> CI:
>    https://urldefense.com/v3/__https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/229689192__;!!GqivPVa7Brio!LehVoD4e6fUc92A7OE_Rxl2QwwkrW4aY0WHTmPkgKyxYviNfnTs3hEmYWHsMj5GdDaIf$
>
>
> Claudio Imbrenda (12):
>    lib/x86: fix page.h to include the generic header
>    lib/list.h: add list_add_tail
>    lib/vmalloc: add some asserts and improvements
>    lib/asm: Fix definitions of memory areas
>    lib/alloc_page: fix and improve the page allocator
>    lib/alloc.h: remove align_min from struct alloc_ops
>    lib/alloc_page: Optimization to skip known empty freelists
>    lib/alloc_page: rework metadata format
>    lib/alloc: replace areas with more generic flags
>    lib/alloc_page: Wire up ZERO_FLAG
>    lib/alloc_page: Properly handle requests for fresh blocks
>    lib/alloc_page: default flags and zero pages by default
>
>   lib/asm-generic/memory_areas.h |   9 +-
>   lib/arm/asm/memory_areas.h     |  11 +-
>   lib/arm64/asm/memory_areas.h   |  11 +-
>   lib/powerpc/asm/memory_areas.h |  11 +-
>   lib/ppc64/asm/memory_areas.h   |  11 +-
>   lib/s390x/asm/memory_areas.h   |  13 +-
>   lib/x86/asm/memory_areas.h     |  27 +--
>   lib/x86/asm/page.h             |   4 +-
>   lib/alloc.h                    |   1 -
>   lib/alloc_page.h               |  66 ++++++--
>   lib/list.h                     |   9 +
>   lib/alloc_page.c               | 291 ++++++++++++++++++++-------------
>   lib/alloc_phys.c               |   9 +-
>   lib/s390x/smp.c                |   2 +-
>   lib/vmalloc.c                  |  21 +--
>   15 files changed, 286 insertions(+), 210 deletions(-)
>
For patch# 1, 2, 7, 8, 9, 10 and 11:

     Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
