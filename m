Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CBB275906
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 15:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIWNpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 09:45:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIWNpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 09:45:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NDck01081530;
        Wed, 23 Sep 2020 13:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=8YXXtXIY8F+6xnk9nWlhsejhsntebN6YBm9vHwY5mXo=;
 b=mxJU4MRv+sMusm7Pq4IxaQojLUuLUU8zngE26yxSlec39jV70/fogYA3hNswyyHkFdsX
 kI+O6/IF7GlHhbWMfOiqPMQau+CA630mSHYV9/vCsbWCQwqTH83mBd0Etq81zyWaB/z5
 EowwB4cbZmgGIlMzxRHqFC8y6g6CeTHeZxSTtb8Gqa1uJmBixZueF6Tt+GOj+zcRSBD1
 lYtykER8husmd6TuNpIJjFRTeXL3dtX7FDRdMUSz42HRHJlXvf2ogz5NG3MESzLjqk+A
 tsXquNkcoNT4+iMo6mDQN+LkL+oKqkCyBIzAlEAxK1yalnqQcGTasEXJwmD35eR/cH33 PA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33ndnujk3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 13:45:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NDfPYG134847;
        Wed, 23 Sep 2020 13:45:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nux1599n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 13:45:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08NDj1j1022552;
        Wed, 23 Sep 2020 13:45:01 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 06:45:01 -0700
Date:   Wed, 23 Sep 2020 16:44:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     mlevitsk@redhat.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] SVM: nSVM: setup nested msr permission bitmap on nested
 state load
Message-ID: <20200923134455.GA1485839@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=495 phishscore=0 suspectscore=10 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=10 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=478 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Maxim Levitsky,

The patch 772b81bb2f9b: "SVM: nSVM: setup nested msr permission
bitmap on nested state load" from Aug 27, 2020, leads to the
following static checker warning:

	arch/x86/kvm/svm/nested.c:1161 svm_set_nested_state()
	warn: 'ctl' not released on lines: 1152.

arch/x86/kvm/svm/nested.c
  1135          if (!(save->cr0 & X86_CR0_PG))
  1136                  goto out_free;
  1137  
  1138          /*
  1139           * All checks done, we can enter guest mode.  L1 control fields
  1140           * come from the nested save state.  Guest state is already
  1141           * in the registers, the save area of the nested state instead
  1142           * contains saved L1 state.
  1143           */
  1144          copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
  1145          hsave->save = *save;
  1146  
  1147          svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
  1148          load_nested_vmcb_control(svm, ctl);
  1149          nested_prepare_vmcb_control(svm);
  1150  
  1151          if (!nested_svm_vmrun_msrpm(svm))
  1152                  return -EINVAL;

goto out_free?

  1153  
  1154          svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
  1155  
  1156          ret = 0;
  1157  out_free:
  1158          kfree(save);
  1159          kfree(ctl);
  1160  
  1161          return ret;
  1162  }

regards,
dan carpenter
