Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109B1109D9E
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 13:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfKZMNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 07:13:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfKZMNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 07:13:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQC8xNl111172;
        Tue, 26 Nov 2019 12:13:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=1tb9hLrlaNp7VV0lwvPvXEASrUtgCPccXZYCxoaP2Bo=;
 b=I0I9H6+3DuMJdB2WD9lPVX/6b/pPVfT7vnBnV1fhSyJqtbwJnJxq6b8Qx4hlGGd/xytD
 wtLZax6bRfTN8LfHbSbx0fliX6yC+8/y++wfImSmyC2EHwXU38/P7HOAEtQDxyG7ToGM
 dwc3vjXWoAbPKcAt5bEFwbbqCNKMuS+ydoXs4LyoC06Lvf5F4bSmtlObnRWmIneaDg6s
 Fe/oEXQKl0O9AuFn3eKvCtDPFRGosqZ4LThqxPkshW7t1CwFHDdcelKRS6bGdITSamfT
 QJGp+q6plzjR8mzw5CYfqbfftXi2XeI6D5812tHadCxM3QLzXMgh/FyEoOB1F+cWs90p +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wevqq6dwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:13:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQC8lVg033708;
        Tue, 26 Nov 2019 12:13:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wgvh9w566-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:13:04 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAQCD3ju017633;
        Tue, 26 Nov 2019 12:13:03 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 04:13:03 -0800
Date:   Tue, 26 Nov 2019 15:12:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     thomas.lendacky@amd.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: SVM: Reduce WBINVD/DF_FLUSH invocations
Message-ID: <20191126121256.6ysl63n3x2jfiyzf@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=355
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911260110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=416 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911260110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Tom Lendacky,

The patch 33af3a7ef9e6: "KVM: SVM: Reduce WBINVD/DF_FLUSH
invocations" from Oct 3, 2019, leads to the following static checker
warning:

	arch/x86/kvm/svm.c:6311 sev_flush_asids()
	error: uninitialized symbol 'error'.

arch/x86/kvm/svm.c
  6295  static int sev_flush_asids(void)
  6296  {
  6297          int ret, error;
  6298  
  6299          /*
  6300           * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
  6301           * so it must be guarded.
  6302           */
  6303          down_write(&sev_deactivate_lock);
  6304  
  6305          wbinvd_on_all_cpus();
  6306          ret = sev_guest_df_flush(&error);
                                         ^^^^^^
  6307  
  6308          up_write(&sev_deactivate_lock);
  6309  
  6310          if (ret)
  6311                  pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
                                                                                 ^^^^^
There are a bunch of error paths were "error" isn't initialized.

  6312  
  6313          return ret;
  6314  }

regards,
dan carpenter
