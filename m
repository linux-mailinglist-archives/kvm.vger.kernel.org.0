Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D32C11EBBD
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 21:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfLMUP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 15:15:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35130 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728932AbfLMUP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 15:15:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDK4M8Q052848;
        Fri, 13 Dec 2019 20:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=TNwH//sjjP0dpv5Zb5O45GTAWkGy6Jy5zU0tVrwrNCk=;
 b=F18byeuDDoK0Av2CaxjNbhA3ASHKdzGPKTrw1Vj38TDKmGbt+zU0oUBsHTNbpSFehz1y
 ixBJKQxe4cCqNO4nBstjiYhn2mwrSCmx3N3F0YSBT6QLbNiDtmk11Zn3YQCQwm/4jz8R
 3dVm+2zCKKo1Knzoo4FobVtE+pg8hbHZHTooEn+agcJWprLwCgKGZJKflJOrNFAySygJ
 0gc+gl7iPZR0Gt+F17IpCWzh8ZQ4CiJYNuBi4T6AkAxYg0HuN4uZ0oyTUT3338j6a8A3
 OG8xLXoOjiv90V3ATGB+5vn0rc8aSra6d++fisKNUG+03h3bNn6ycMRTxrd+Mt3dXw4M Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wr4qs32ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 20:12:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDK9OAE010187;
        Fri, 13 Dec 2019 20:12:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wvdwqnq06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 20:12:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBDKCUlG030058;
        Fri, 13 Dec 2019 20:12:30 GMT
Received: from char.us.oracle.com (/10.152.32.25) by default (Oracle Beehive
 Gateway v4.0) with ESMTP ; Fri, 13 Dec 2019 12:12:29 -0800
Received: by char.us.oracle.com (Postfix, from userid 1000) id 7E0D56A00F0;
 Fri, 13 Dec 2019 15:15:56 -0500 (EST)
USER-AGENT: Mutt/1.9.1 (2017-09-22)
MIME-Version: 1.0
Message-ID: <20191213201556.GC26990@char.us.oracle.com>
Date:   Fri, 13 Dec 2019 12:15:56 -0800 (PST)
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH RFC v4 00/13] virtio-mem: paravirtualized memory
References: <20191212171137.13872-1-david@redhat.com>
In-Reply-To: <20191212171137.13872-1-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 06:11:24PM +0100, David Hildenbrand wrote:
> This series is based on latest linux-next. The patches are located at:
>     https://github.com/davidhildenbrand/linux.git virtio-mem-rfc-v4
Heya!

Would there be by any chance a virtio-spec git tree somewhere?

..snip..
> --------------------------------------------------------------------------
> 5. Future work
> --------------------------------------------------------------------------
> 
> The separate patches contain a lot of future work items. One of the next
> steps is to make memory unplug more likely to succeed - currently, there
> are no guarantees on how much memory can get unplugged again. I have


Or perhaps tell the caller why we can't and let them sort it out?
For example: "Application XYZ is mlocked. Can't offload'.


