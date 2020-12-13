Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B289F2D90EC
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 23:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406269AbgLMWaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 17:30:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731175AbgLMWaC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 13 Dec 2020 17:30:02 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BDMBj9G059546;
        Sun, 13 Dec 2020 17:29:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=V1zmJvv/J3Tu5Mv95QCY0IBPJcTkOgwk4YgXrqAO/4Y=;
 b=hNxa4ezFneSS1MzDUBGKBAgDA+H3ZsflcGMkt7riU//8aByBlweOpOsvCxyxbVrObCSx
 QibWQX3fUL/o2yBEYiomUyxIPs8DAPTf00PFfRk6ixJYSTjRTeweuC1uaVTXdgDmCx3e
 /FrFrzIB0orWysdl20dD3NE+jkw1CG964p70lgSjoEfrMmcuPXdEUD9iqtGOYjHCBch1
 IUrPLev1ON0j/5U69rqS0JLlyev6usHQie9VLVtVvmf1VMEVAharzKq4V9vk3g90h6su
 EhlGt8C5zkLe3ef0gt/CYNIbT6uCnUzdfLmXxF7H25DedrgRfxzf7qUMNZZIIX8xCQcn cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35duhkg9ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 17:29:03 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BDMS13G108405;
        Sun, 13 Dec 2020 17:29:03 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35duhkg9w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 17:29:03 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BDMSAL2015673;
        Sun, 13 Dec 2020 22:29:02 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 35cng8kf3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 22:29:02 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BDMT14X24510782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 22:29:01 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 297FD7805C;
        Sun, 13 Dec 2020 22:29:01 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13C6D7805E;
        Sun, 13 Dec 2020 22:28:58 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.214.106])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 13 Dec 2020 22:28:57 +0000 (GMT)
Message-ID: <5d0085a960956ce8d9eae06465313012d448189c.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM/SVM: add support for SEV attestation command
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date:   Sun, 13 Dec 2020 14:28:56 -0800
In-Reply-To: <78e18a3d-900b-fac5-19ca-c2defeb8d73a@amd.com>
References: <20201204212847.13256-1-brijesh.singh@amd.com>
         <CAMj1kXFkyJwZ4BGSU-4UB5VR1etJ6atb7YpWMTzzBuu9FQKagA@mail.gmail.com>
         <78e18a3d-900b-fac5-19ca-c2defeb8d73a@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-13_06:2020-12-11,2020-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 clxscore=1011 mlxscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130169
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-12-09 at 21:25 -0600, Brijesh Singh wrote:
> Noted, I will send v2 with these fixed.

I ran a test on this.  It turns out for rome systems you need firmware
md_sev_fam17h_model3xh_0.24b0A (or later) installed to get this and the
QEMU patch with the base64 decoding fixed, but with that

Tested-by: James Bottomley <jejb@linux.ibm.com>

Attached is the test programme I used.

James

---

#!/usr/bin/python3
##
# Python script get an attestation and verify it with the PEK
#
# This assumes you've already exported the pek.cert with sev-tool
# from https://github.com/AMDESE/sev-tool.git
#
# sev-tool --export_cert_chain
#
# creates several files, the only one this script needs is pek.cert
#
# Tables and chapters refer to the amd 55766.pdf document
#
# https://www.amd.com/system/files/TechDocs/55766_SEV-KM_API_Specification.pdf
##
import sys
import os 
import base64
import hashlib
from argparse import ArgumentParser
from Crypto.PublicKey import ECC
from Crypto.Math.Numbers import Integer
from git.qemu.python.qemu import qmp

if __name__ == "__main__":
    parser = ArgumentParser(description='Inject secret into SEV')
    parser.add_argument('--pek-cert',
                        help='The Platform DH certificate in binary form',
                        default='pek.cert')
    parser.add_argument('--socket',
                        help='Socket to connect to QMP on, defaults to localhost:6550',
                        default='localhost:6550')
    args = parser.parse_args()

    if (args.socket[0] == '/'):
        socket = args.socket
    elif (':' in args.socket):
        s = args.socket.split(':')
        socket = (s[0], int(s[1]))
    else:
        parse.error('--socket must be <host>:<port> or /path/to/unix')

    fh = open(args.pek_cert, 'rb')
    pek = bytearray(fh.read())
    curve = int.from_bytes(pek[16:20], byteorder='little')
    curves = {
        1: 'p256',
        2: 'p384'
        }
    Qx = int.from_bytes(bytes(pek[20:92]), byteorder='little')
    Qy = int.from_bytes(bytes(pek[92:164]), byteorder='little')

    pubkey = ECC.construct(point_x=Qx, point_y=Qy, curve=curves[curve])

    Qmp = qmp.QEMUMonitorProtocol(address=socket);
    Qmp.connect()
    caps = Qmp.command('query-sev')
    print('SEV query found API={api-major}.{api-minor} build={build-id} policy={policy}\n'.format(**caps))

    nonce=os.urandom(16)

    report = Qmp.command('query-sev-attestation-report',
                         mnonce=base64.b64encode(nonce).decode())

    a = base64.b64decode(report['data'])

    ##
    # returned data is formulated as Table 60. Attestation Report Buffer
    ##
    rnonce = a[0:16]
    rmeas = a[16:48]

    if (nonce != rnonce):
        sys.exit('returned nonce doesn\'t match input nonce')

    policy = int.from_bytes(a[48:52], byteorder='little')
    usage = int.from_bytes(a[52:56], byteorder='little')
    algo = int.from_bytes(a[56:60], byteorder='little')

    if (policy != caps['policy']):
        sys.exit('Policy mismatch:', policy, '!=', caps['policy'])

    if (usage != 0x1002):
        sys.exit('error PEK is not specified in usage: ', usage)

    if (algo == 0x2):
        h = hashlib.sha256()
    elif (algo == 0x102):
        ##
        # The spec (6.8) says the signature must be ECDSA-SHA256 so this
        # should be impossible, but it turns out to be the way our
        # current test hardware produces its signature
        ##
        h = hashlib.sha384()
    else:
        sys.exit('unrecognized signing algorithm: ', algo)

    h.update(a[0:52])

    sig = a[64:208]
    r = int.from_bytes(sig[0:72],byteorder='little')
    s = int.from_bytes(sig[72:144],byteorder='little')
    ##
    # subtlety: r and s are little (AMD defined) z is big (crypto requirement)
    ##
    z = int.from_bytes(h.digest(), byteorder='big')

    ##
    # python crypto doesn't have a way of passing in r and s as
    # integers and I'm not inclined to wrap them up as a big endian
    # binary signature to have Signature.DSS unwrap them again, so
    # call the _verify() private interface that does take integers
    ##
    if (not pubkey._verify(Integer(z), (Integer(r), Integer(s)))):
        sys.exit('returned signature did not verify')

    print('usage={usage}, algorithm={algo}'.format(usage=hex(usage),
                                                   algo=hex(algo)))
    print('ovmf-hash: ', rmeas.hex())

