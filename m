Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82398F7895
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKKQRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:17:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53928 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbfKKQRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 11:17:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABGGxC6023582;
        Mon, 11 Nov 2019 16:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=+XlnBIGr0f6DHQOAeAIB/PAXvooJeHW2AKZcgW65K7M=;
 b=rgS1ExlgiFgAK5a1gd5ka+cc9uihXJG+JOffbGdm1H6b5xgdwBc/bSE1Gni5sYGwBdzI
 LJK9n4x1Gb76NUTF9RVcuYyWavYjoXDFsC7Xyv1/QaDAfH47s1ioCweg61mW126r11x9
 W8XjwF4UyZ7IH/qYGt4tvVZgW3tld+sf48iZ1LQlZxDOnh2K81A2tbclHpjU7YpDb71v
 5M9rKOVmwglhDzGJk3PFxQcQJ62tvFRMf84eTQ863UyL8L7oXoJdp9spGS5FksfLo/7o
 dIMXoqauixO0MgE8Xnf1bYXgBUdlsO5fZPqALGdW+WxoVb9DqMsVeS8/6ylwpJwd603b Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w5mvtfwy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 16:17:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABGHL8G139543;
        Mon, 11 Nov 2019 16:17:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w66wmd11u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 16:17:30 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABGH5AZ020818;
        Mon, 11 Nov 2019 16:17:05 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 08:17:05 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: nVMX: Update vmcs01 TPR_THRESHOLD if L2 changed
 L1 TPR
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <72c26523-702a-df0c-5573-982da25cba19@redhat.com>
Date:   Mon, 11 Nov 2019 18:17:01 +0200
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD8FF780-C38E-493C-9BDE-FAFC1B3D25D6@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
 <20191111123055.93270-3-liran.alon@oracle.com>
 <a26a9a8c-df8d-c49a-3943-35424897b6b3@redhat.com>
 <6CAEE592-02B0-4E25-B2D2-20E5B55A5D19@oracle.com>
 <72c26523-702a-df0c-5573-982da25cba19@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11 Nov 2019, at 18:07, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 11/11/19 16:24, Liran Alon wrote:
>>> Can you explain why the write shouldn't be done to vmcs02 as well?
>>=20
>> Because when L1 don=E2=80=99t use TPR-Shadow, L0 configures vmcs02 =
without TPR-Shadow.
>> Thus, writing to vmcs02->tpr_threshold doesn=E2=80=99t have any =
effect.
>>=20
>> If l1 do use TPR-Shadow, then VMX=E2=80=99s update_cr8_intercept() =
doesn=E2=80=99t write to vmcs at all,
>> because it means L1 defines a vTPR for L2 and thus doesn=E2=80=99t =
provide it direct access to L1 TPR.
>=20
> But I'm still not sure about another aspect of the patch.  The write =
to
> vmcs01 can be done even if TPR_SHADOW was set in vmcs12, because no =
one
> takes care of clearing vmx->nested.l1_tpr_threshold.  Should
> "vmx->nested.l1_tpr_threshold =3D -1;" be outside the if?

If I understand you correctly, you refer to the case where L1 first =
enters L2 without TPR-Shadow,
then L2 lowers L1 TPR directly (which load vmx->nested.l1_tpr_threshold =
with value), then an
emualted exit happen from L2 to L1 which writes to vmcs01->tpr_threshold =
the value of
vmx->nested.l1_tpr_threshold. Then L1 enters again L2 but this time with =
TPR-Shadow and
prepare_vmcs02_early() doesn=E2=80=99t clear =
vmx->nested.l1_tpr_threshold which will cause next
exit from L2 to L1 to wrongly write the value of =
vmx->nested.l1_tpr_threshold to vmcs01->tpr_threshold.

So yes I think you are right. Good catch.
We should move vmx->nested.l1_tpr_threshold =3D -1; outside of the if.
Should I send v2 or will you change on apply?

>=20
> Also, what happens to_vmx(vcpu)->nested.l1_tpr_threshold if the guest =
is
> migrated while L2 is running without TPR shadow?  Perhaps it would be
> easier to just rerun update_cr8_intercept on nested_vmx_vmexit.
>=20

On restore of state during migration, kvm_apic_set_state() must be =
called which
will also request a KVM_REQ_EVENT which will make sure to call =
update_cr8_intercept().
If vCPU is currently in guest-mode, this should update =
vmx->nested.l1_tpr_threshold.

-Liran

> Paolo


