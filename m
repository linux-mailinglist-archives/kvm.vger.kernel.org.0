Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72AF5149EE9
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 07:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgA0GEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 01:04:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45282 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgA0GEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 01:04:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00R634Yg111279;
        Mon, 27 Jan 2020 06:04:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=lz3HdoGZUpuAH1u0ythHySoMBqzCFy3wPQCnEkmdTHY=;
 b=hwpaZM12mKEUFBXosQ1jgQP0wa12aKtxH0H0Vu95JNRF5cksLJhwEBBQ9J2S5oRCN6ue
 Ou+aXrS3hC/EYeDJtX2nEom+Bv2DC2vU5rJ/kO4gFdCm6kjeE1sxH4hTJqT1wxvcsy3L
 Y41bXOTnXmuvMhDQZ5QowCsStFYNomMbxDMd0cVSwmLe5A4YI71gczrlCW5QPXovGcDe
 9amV8esJE/4H6OB6NPdx8v7nHUGofkk8YOVX4BQEo0Jhn1FHioHJYUhkf7C6viCalBOq
 QiEdCIY7JsLifyE+0c8jXmVia0ycGdpfp7VeDqPzAuZDFyRKjaXZNTcIKFebIJHVLquy Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xrdmq589t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 06:04:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00R63fWL088375;
        Mon, 27 Jan 2020 06:04:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xry6qny1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 06:04:30 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00R64T4o008856;
        Mon, 27 Jan 2020 06:04:29 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 22:04:28 -0800
Date:   Mon, 27 Jan 2020 09:04:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: x86: avoid incorrect writes to host
 MSR_IA32_SPEC_CTRL
Message-ID: <20200127060305.jlq5uv6tu67tsbv4@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=666
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001270052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=721 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001270052
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo Bonzini,

The patch e71ae535bc24: "KVM: x86: avoid incorrect writes to host
MSR_IA32_SPEC_CTRL" from Jan 20, 2020, leads to the following static
checker warning:

	arch/x86/kvm/vmx/vmx.c:2001 vmx_set_msr()
	warn: maybe use && instead of &

arch/x86/kvm/vmx/vmx.c
  1994                  vmx->msr_ia32_umwait_control = data;
  1995                  break;
  1996          case MSR_IA32_SPEC_CTRL:
  1997                  if (!msr_info->host_initiated &&
  1998                      !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
  1999                          return 1;
  2000  
  2001                  if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^

This seems wrong.  kvm_spec_ctrl_valid_bits() returns a bool so this
is either 0xffffffff or 0xfffffffe.  data is a u64.

  2002                          return 1;
  2003  
  2004                  vmx->spec_ctrl = data;
  2005                  if (!data)
  2006                          break;
  2007  
  2008                  /*
  2009                   * For non-nested:

regards,
dan carpenter
