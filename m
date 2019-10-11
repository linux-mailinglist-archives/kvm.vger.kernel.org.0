Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F280D47D8
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 20:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfJKSs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 14:48:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbfJKSs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 14:48:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9BIiGNX067169;
        Fri, 11 Oct 2019 18:47:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=rpJscLwPGAkcPkqG6xTibJV0h75UV6LbBcqJXO4tp4A=;
 b=D7RikZpnJzDBUu5h49Wd31aSymia6cOyPJLcWIYLHXKit3u6Xc2f4XkjgbuDeY/d2MnA
 X0TDfnTEb4OjqBvDVFRsp1S2xv82VW4stdUj9/l6jTh9L91iMK5GPq5Gyc8wlGAawLWz
 b2lZRGHL1BivdM4S/SdtC0OjF9RNC5X7jAxYq9KMDRfDLmEOG55c++azMyaaNZIJY/5J
 +0c6jKJCwpCuhAmqcBkdFTVsV3/yY8A+KFJz5Q/p1pwdLKZzHG0JBAKPx5qc6WLCnmgN
 /ANI0q2R+yUPEX6EGE5TfSfu7QFtFFbOi8TPIvex8HWf0K/cxFYLQbFcMJaQO5EuK/XX ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vejkv3fjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Oct 2019 18:47:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9BIlkoC071640;
        Fri, 11 Oct 2019 18:47:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vj9qvhpqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Oct 2019 18:47:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9BIlWIC013390;
        Fri, 11 Oct 2019 18:47:32 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Oct 2019 18:47:32 +0000
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 564936A00F3; Fri, 11 Oct 2019 14:50:50 -0400 (EDT)
Date:   Fri, 11 Oct 2019 14:50:50 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Roman Kagan <rkagan@virtuozzo.com>,
        Suleiman Souhlal <suleiman@google.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, tglx@linutronix.de, john.stultz@linaro.org,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ssouhlal@freebsd.org, tfiga@chromium.org,
        vkuznets@redhat.com
Subject: Re: [RFC v2 0/2] kvm: Use host timekeeping in guest.
Message-ID: <20191011185050.GJ691@char.us.oracle.com>
References: <20191010073055.183635-1-suleiman@google.com>
 <20191010103939.GA12088@rkaganb.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010103939.GA12088@rkaganb.sw.ru>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=18 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=979
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910110158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=18 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910110157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

.snip..
> I wonder how feasible it is to map the host's vdso into the guest and
> thus make the guest use the *same* (as opposed to "synchronized") clock
> as the host's userspace?  Another benefit is that it's essentially an
> ABI so is not changed as liberally as internal structures like
> timekeeper, etc.  There is probably certain complication in handling the
> syscall fallback in the vdso when used in the guest kernel, though.
> 
> You'll also need to ensure neither tsc scaling and nor offsetting is
> applied to the VM once this clock is enabled.

This is how Xen does it - you can register the hypervisor to timestamp
your vDSO regions if you want it. See xen_setup_vsyscall_time_info

> 
> Roman.
