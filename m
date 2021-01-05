Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EBE2EB342
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 20:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbhAETDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 14:03:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730760AbhAETDK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 14:03:10 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 105J1aw3071592;
        Tue, 5 Jan 2021 14:02:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=/cZUXh8b1x936QtrNe8FlKnGgzof/dN1oIoASK198dg=;
 b=UXfNL5aEhSnlmHRYjEZ+Ww7JdZaBpBP7Jp55z3FWQOz0cnefKLEyB+u/RZW6o/2sgOfE
 GGH3/cVGkR5pI2/dorvy9zeEQdYJg3oNojuPrAlqzejTwy0e60e+RZ71LDbLNvDa/xTn
 S9vqObZgVJbmJYqc/U5Lot6cpkNLxbudCFQBmBdla+8EOROQBCosfiNdGLev9ovBNrQW
 3p2S1bR/MpO7EA5PJ+pcPgOoy+cIVqlhgfwYetjKbhYa33kMXaz7i8q9W+1nxYzUefDp
 fqmYFP+4GPLHyQJHrHpPfwOaWmqiAmrbbkTeY5GJTZPS4dRD8aqkGZ+r4vEI7TfoPojy ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35vwueg340-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jan 2021 14:02:22 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 105J1rc3072445;
        Tue, 5 Jan 2021 14:02:21 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35vwueg33q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jan 2021 14:02:21 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 105IvkKZ024463;
        Tue, 5 Jan 2021 19:02:21 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 35tgf8wp48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jan 2021 19:02:21 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 105J2Kb321561762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jan 2021 19:02:20 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEF277805F;
        Tue,  5 Jan 2021 19:02:19 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C09717805E;
        Tue,  5 Jan 2021 19:02:18 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.172.80])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jan 2021 19:02:18 +0000 (GMT)
Message-ID: <b290205e2233f4bda699a09b3329bc052be72749.camel@linux.ibm.com>
Subject: Re: [PATCH v2] target/i386/sev: add support to query the
 attestation report
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org
Cc:     Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Date:   Tue, 05 Jan 2021 11:02:17 -0800
In-Reply-To: <20210105163943.30510-1-brijesh.singh@amd.com>
References: <20210105163943.30510-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_05:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 phishscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-05 at 10:39 -0600, Brijesh Singh wrote:
> The SEV FW >= 0.23 added a new command that can be used to query the
> attestation report containing the SHA-256 digest of the guest memory
> and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.
> 
> Note, we already have a command (LAUNCH_MEASURE) that can be used to
> query the SHA-256 digest of the guest memory encrypted through the
> LAUNCH_UPDATE. The main difference between previous and this command
> is that the report is signed with the PEK and unlike the
> LAUNCH_MEASURE
> command the ATTESATION_REPORT command can be called while the guest
> is running.
> 
> Add a QMP interface "query-sev-attestation-report" that can be used
> to get the report encoded in base64.
> 
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Eric Blake <eblake@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
> v2:
>   * add trace event.
>   * fix the goto to return NULL on failure.
>   * make the mnonce as a base64 encoded string

Yes, that fixes all my issues, thanks!

Reviewed-by: James Bottomley <jejb@linux.ibm.com>
Tested-by: James Bottomley <jejb@linux.ibm.com>

I've also attached a python script below which I've used to verify the
attestation.

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

