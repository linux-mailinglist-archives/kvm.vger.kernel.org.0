Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D2A36E5D0
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 09:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhD2HVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 03:21:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52090 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239407AbhD2HVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 03:21:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T7Jh0m145112;
        Thu, 29 Apr 2021 07:19:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=qlkw3GdD7MbVkGxTT6+tnURUOd7Q+ftP9f8kgTPWTw4=;
 b=a/ihrMBOtt/etgIcYqT32MfpxWfk7Pilf6b8LWJWMVMa/LGJzbzAC24pZqUoHlxsOOxA
 FyxTANTQM1h0iglKxjFajToBCcqn/Oz2OAY41KScv/jlfrljmw5R7RaR85qw18jjYNZ3
 Y+VSDdKxEM6zew5FzaHVmDMoDzBMFY2pVXfeh07rSSMKfXOuh0f+rnWcTga3KjOfKI5p
 J7mNcinzFBqmS6kUV0yPkX51QL9GNfZ7acH2JjFqVxJwz3vI/wVLhtWXuB6znGV+zRCg
 IC/4iwQ2JILFmrKP4KvpSD03422pvI0wcmhiKMF/qt/xm77WT2ACp9s/HVlvC+3USrW+ 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 385ahbu95b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 07:19:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T7EoD1105964;
        Thu, 29 Apr 2021 07:19:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3874d34yh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 07:19:57 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13T7Fflv109852;
        Thu, 29 Apr 2021 07:19:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3874d34ygb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 07:19:57 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13T7Jt5o015479;
        Thu, 29 Apr 2021 07:19:56 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Apr 2021 07:19:55 +0000
Date:   Thu, 29 Apr 2021 10:19:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     rientjes@google.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: SVM: prevent DBG_DECRYPT and DBG_ENCRYPT overflow
Message-ID: <YIpeFsdjT5Fz5FWZ@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: ZGbzjQ2vHteUi9nYb9bKpM6HaUfELPxi
X-Proofpoint-ORIG-GUID: ZGbzjQ2vHteUi9nYb9bKpM6HaUfELPxi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello David Rientjes,

The patch b86bc2858b38: "KVM: SVM: prevent DBG_DECRYPT and
DBG_ENCRYPT overflow" from Mar 25, 2019, leads to the following
static checker warning:

	arch/x86/kvm/svm/sev.c:960 sev_dbg_crypt()
	error: uninitialized symbol 'ret'.

arch/x86/kvm/svm/sev.c
   879  static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
   880  {
   881          unsigned long vaddr, vaddr_end, next_vaddr;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   882          unsigned long dst_vaddr;
                ^^^^^^^^^^^^^^^^^^^^^^^^

These are unsigned long

   883          struct page **src_p, **dst_p;
   884          struct kvm_sev_dbg debug;
   885          unsigned long n;
   886          unsigned int size;
   887          int ret;
   888  
   889          if (!sev_guest(kvm))
   890                  return -ENOTTY;
   891  
   892          if (copy_from_user(&debug, (void __user *)(uintptr_t)argp->data, sizeof(debug)))
   893                  return -EFAULT;
   894  
   895          if (!debug.len || debug.src_uaddr + debug.len < debug.src_uaddr)
                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
But these are u64 so this could still overflow on 32 bit.  Do we care?

   896                  return -EINVAL;
   897          if (!debug.dst_uaddr)
   898                  return -EINVAL;
   899  
   900          vaddr = debug.src_uaddr;
   901          size = debug.len;
   902          vaddr_end = vaddr + size;
   903          dst_vaddr = debug.dst_uaddr;
   904  
   905          for (; vaddr < vaddr_end; vaddr = next_vaddr) {
   906                  int len, s_off, d_off;
   907  
   908                  /* lock userspace source and destination page */
   909                  src_p = sev_pin_memory(kvm, vaddr & PAGE_MASK, PAGE_SIZE, &n, 0);
   910                  if (IS_ERR(src_p))
   911                          return PTR_ERR(src_p);
   912  
   913                  dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
   914                  if (IS_ERR(dst_p)) {
   915                          sev_unpin_memory(kvm, src_p, n);
   916                          return PTR_ERR(dst_p);
   917                  }
   918  
   919                  /*
   920                   * Flush (on non-coherent CPUs) before DBG_{DE,EN}CRYPT read or modify
   921                   * the pages; flush the destination too so that future accesses do not
   922                   * see stale data.
   923                   */
   924                  sev_clflush_pages(src_p, 1);
   925                  sev_clflush_pages(dst_p, 1);
   926  
   927                  /*
   928                   * Since user buffer may not be page aligned, calculate the
   929                   * offset within the page.
   930                   */
   931                  s_off = vaddr & ~PAGE_MASK;
   932                  d_off = dst_vaddr & ~PAGE_MASK;
   933                  len = min_t(size_t, (PAGE_SIZE - s_off), size);
   934  
   935                  if (dec)
   936                          ret = __sev_dbg_decrypt_user(kvm,
   937                                                       __sme_page_pa(src_p[0]) + s_off,
   938                                                       dst_vaddr,
   939                                                       __sme_page_pa(dst_p[0]) + d_off,
   940                                                       len, &argp->error);
   941                  else
   942                          ret = __sev_dbg_encrypt_user(kvm,
   943                                                       __sme_page_pa(src_p[0]) + s_off,
   944                                                       vaddr,
   945                                                       __sme_page_pa(dst_p[0]) + d_off,
   946                                                       dst_vaddr,
   947                                                       len, &argp->error);
   948  
   949                  sev_unpin_memory(kvm, src_p, n);
   950                  sev_unpin_memory(kvm, dst_p, n);
   951  
   952                  if (ret)
   953                          goto err;
   954  
   955                  next_vaddr = vaddr + len;
   956                  dst_vaddr = dst_vaddr + len;
   957                  size -= len;
   958          }
   959  err:
   960          return ret;
   961  }

regards,
dan carpenter
