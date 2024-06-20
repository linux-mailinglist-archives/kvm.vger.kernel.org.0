Return-Path: <kvm+bounces-20087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 999299107E7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B86FF1C20DE2
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D54B1A8C31;
	Thu, 20 Jun 2024 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aKyIWmrV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A756F1AD483;
	Thu, 20 Jun 2024 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893038; cv=none; b=FPbUOmvXW2GA3cIvZTi+6Ws4GPNCV3pBfAlya5seSLGv1C53vGkX3AW2HkekXvkQHjBFOTuo5KgAOenzl2zPpL0dP5Lto3kBBhtIDbsMo4cuzthDMvw18+hK9Dp77uLBH3GsD9Eay7N6cUi1ybzdaVWxhaGKzsWWq5xGpjQ+4BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893038; c=relaxed/simple;
	bh=aqMDKPV3iu3Y4sA0CpCDc+eqRVw3CJGgvOfLX6fLJyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Io2Stn1ZMCdLlH3M469ULb0g9Qd0uY6jExm9g8TFP4h77MdxMT9gKL6ZfJuV6QOHI9Qpif/qxHztFoFFF5qbw+Vg041T7nhx0ztl9Jf8463UGKT4eZMmEjRUMDFNY0I1rOk3GziKsBmgWY6y2QQsj+WZOEjRz7lWfO5vfb5axKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aKyIWmrV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KDwhr7023531;
	Thu, 20 Jun 2024 14:17:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=rNoHxJIwcJFfm
	6hdfl+KkBYDEFsUdZO3t9hC7J/CON4=; b=aKyIWmrVjIfaKQ9FLNnOzOU3v+3L+
	sjtdSYflA4RjkNaYH7ED8AHvGNGXShwapmIrulR39dHWMffqO1xXBOdKVKZ66QND
	F8kivmTemY/GU/ZTMLXDnabVm0SuftyHHp0e8qui1dZfMDOyzQq19IVInuNrcnax
	5eOXu7P199mDTQTkV1fY/2iL+LvS+BUc9xmvKlwzV+gAor8+/SrzDNpJnzKqTLoJ
	fUpxRVLSwrL4F+C5dCGf4yssloxZBVrRnZ3Y5a04N7l4unT9VUgeuLkOewxt4SGJ
	MJO4OwgoHt34AtNg3KxOehVt3drDMSXaIWHL8cNNbqO9vVVvgVXUnn+IA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnsar1td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:10 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KEH9nK023151;
	Thu, 20 Jun 2024 14:17:09 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnsar1tb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KDvfrT019545;
	Thu, 20 Jun 2024 14:17:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ysnp1q004-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:08 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KEH2RQ51249452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 14:17:04 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D7BF2004B;
	Thu, 20 Jun 2024 14:17:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F3622004E;
	Thu, 20 Jun 2024 14:17:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 14:17:02 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Nico Boehr <nrb@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: linux-s390@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/7] lib: Add pseudo random functions
Date: Thu, 20 Jun 2024 16:16:54 +0200
Message-Id: <20240620141700.4124157-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240620141700.4124157-1-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: beDaDAhvyuBkJ9HNqQWBSIRTtQkNS5GY
X-Proofpoint-GUID: qsYGq10zvxbjlaPK2LZfxlAIctcIgbR9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200099

Add functions for generating pseudo random 32 and 64 bit values.
The implementation uses SHA-256 and so the randomness should have good
quality.
Implement the necessary subset of SHA-256.
The PRNG algorithm is equivalent to the following python snippet:

def prng32(seed):
    from hashlib import sha256
    state = seed.to_bytes(8, byteorder="big")
    while True:
        state = sha256(state).digest()
        for i in range(8):
            yield int.from_bytes(state[i*4:(i+1)*4], byteorder="big")

Acked-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---

Notes:
    Since a PRNG with better quality was asked for I decided to use SHA-256
    because:
     * it is a standard, commonly used algorithm
     * high quality randomness is assured
     * the implementation can be checked against the spec
     * the implementation can be easily checked via comparison
    
    I tested the implementation in the following way:
    
    cat <<'EOF' > rand.py
    #!/usr/bin/python3
    
    def prng32(seed):
        from hashlib import sha256
        state = seed.to_bytes(8, byteorder="big")
        while True:
            state = sha256(state).digest()
            for i in range(8):
                yield int.from_bytes(state[i*4:(i+1)*4], byteorder="big")
    
    r = prng32(0)
    for i in range(100):
        print(f"{next(r):08x}")
    
    EOF
    
    cat <<'EOF' > rand.c
    #include <stdio.h>
    #include "rand.h"
    
    void main(void)
    {
    	prng_state state = prng_init(0);
    	for (int i = 0; i < 100; i++) {
    		printf("%08x\n", prng32(&state));
    	}
    }
    EOF
    cat <<'EOF' > libcflat.h
    #define ARRAY_SIZE(_a) (sizeof(_a)/sizeof((_a)[0]))
    EOF
    chmod +x rand.py
    ln -s lib/rand.c librand.c
    gcc -Ilib librand.c rand.c
    diff <(./a.out) <(./rand.py)

 Makefile   |   1 +
 lib/rand.h |  21 +++++++
 lib/rand.c | 177 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 199 insertions(+)
 create mode 100644 lib/rand.h
 create mode 100644 lib/rand.c

diff --git a/Makefile b/Makefile
index 5b7998b7..3d51cb72 100644
--- a/Makefile
+++ b/Makefile
@@ -28,6 +28,7 @@ cflatobjs := \
 	lib/printf.o \
 	lib/string.o \
 	lib/abort.o \
+	lib/rand.o \
 	lib/report.o \
 	lib/stack.o
 
diff --git a/lib/rand.h b/lib/rand.h
new file mode 100644
index 00000000..cdce8bd7
--- /dev/null
+++ b/lib/rand.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * (pseudo) random functions
+ *
+ * Copyright IBM Corp. 2024
+ */
+#ifndef _RAND_H_
+#define _RAND_H_
+
+#include <stdint.h>
+
+/* Non cryptographically secure PRNG */
+typedef struct {
+	uint32_t hash[8];
+	uint8_t next_word;
+} prng_state;
+prng_state prng_init(uint64_t seed);
+uint32_t prng32(prng_state *state);
+uint64_t prng64(prng_state *state);
+
+#endif /* _RAND_H_ */
diff --git a/lib/rand.c b/lib/rand.c
new file mode 100644
index 00000000..583d2d9f
--- /dev/null
+++ b/lib/rand.c
@@ -0,0 +1,177 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * (pseudo) random functions
+ * Currently uses SHA-256 to scramble the PRNG state.
+ *
+ * Copyright IBM Corp. 2024
+ */
+
+#include "libcflat.h"
+#include "rand.h"
+#include <string.h>
+
+/* Begin SHA-256 related definitions */
+
+#define INITAL_HASH { \
+	0x6a09e667, \
+	0xbb67ae85, \
+	0x3c6ef372, \
+	0xa54ff53a, \
+	0x510e527f, \
+	0x9b05688c, \
+	0x1f83d9ab, \
+	0x5be0cd19, \
+}
+
+static const uint32_t K[] = {
+	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
+	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
+	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
+	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
+	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
+	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
+	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
+	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
+};
+
+static inline uint32_t ch(uint32_t x, uint32_t y, uint32_t z)
+{
+	return (x & y) ^ ((~x) & z);
+}
+
+static inline uint32_t maj(uint32_t x, uint32_t y, uint32_t z)
+{
+	return (x & y) ^ (x & z) ^ (y & z);
+}
+
+static inline uint32_t rot(uint32_t value, unsigned int count)
+{
+	return value >> count | value << (32 - count);
+}
+
+static inline uint32_t upper_sig0(uint32_t x)
+{
+	return rot(x, 2) ^ rot(x, 13) ^ rot(x, 22);
+}
+
+static inline uint32_t upper_sig1(uint32_t x)
+{
+	return rot(x, 6) ^ rot(x, 11) ^ rot(x, 25);
+}
+
+static inline uint32_t lower_sig0(uint32_t x)
+{
+	return rot(x, 7) ^ rot(x, 18) ^ (x >> 3);
+}
+
+static inline uint32_t lower_sig1(uint32_t x)
+{
+	return rot(x, 17) ^ rot(x, 19) ^ (x >> 10);
+}
+
+enum alphabet { A, B, C, D, E, F, G, H, };
+
+static void sha256_chunk(const uint32_t (*chunk)[16], uint32_t (*hash)[8])
+{
+	uint32_t w[64];
+	uint32_t w_hash[8];
+
+	memcpy(w, chunk, sizeof(*chunk));
+
+	for (int i = 16; i < 64; i++)
+		w[i] = lower_sig1(w[i - 2]) + w[i - 7] + lower_sig0(w[i - 15]) + w[i - 16];
+
+	memcpy(w_hash, hash, sizeof(*hash));
+
+	for (int i = 0; i < 64; i++) {
+		uint32_t t1, t2;
+
+		t1 = w_hash[H] +
+		     upper_sig1(w_hash[E]) +
+		     ch(w_hash[E], w_hash[F], w_hash[G]) +
+		     K[i] +
+		     w[i];
+
+		t2 = upper_sig0(w_hash[A]) + maj(w_hash[A], w_hash[B], w_hash[C]);
+
+		w_hash[H] = w_hash[G];
+		w_hash[G] = w_hash[F];
+		w_hash[F] = w_hash[E];
+		w_hash[E] = w_hash[D] + t1;
+		w_hash[D] = w_hash[C];
+		w_hash[C] = w_hash[B];
+		w_hash[B] = w_hash[A];
+		w_hash[A] = t1 + t2;
+	}
+
+	for (int i = 0; i < 8; i++)
+		(*hash)[i] += w_hash[i];
+}
+
+/**
+ * sha256_hash - Calculate SHA-256 of input. Only a limited subset of inputs supported.
+ * @n: Number of words to hash, must be <= 13
+ * @input: Input data to hash
+ * @hash: Output hash as a word array, ordered such that the first word contains
+ *        the first/leftmost bits of the 256 bit hash
+ *
+ * Calculate the SHA-256 hash of the input where the input must be a multiple of
+ * 4 bytes and at most 52 long. The input is used without any adjustment, so,
+ * should the caller want to hash bytes it needs to interpret the bytes in the
+ * ordering as defined by the specification, that is big endian.
+ * The same applies to interpreting the output array as bytes.
+ * The function computes the same as: printf "%08x" ${input[@]} | xxd -r -p | sha256sum .
+ */
+static void sha256_hash(unsigned int n, const uint32_t (*input)[n], uint32_t (*hash)[8])
+{
+	/*
+	 * Pad according to SHA-2 specification.
+	 * First set up length in bits.
+	 */
+	uint32_t chunk[16] = {
+		[15] = sizeof(*input) * 8,
+	};
+
+	memcpy(chunk, input, sizeof(*input));
+	/* Then add separator */
+	chunk[n] = 1 << 31;
+	memcpy(hash, (uint32_t[])INITAL_HASH, sizeof(*hash));
+	sha256_chunk(&chunk, hash);
+}
+
+/* End SHA-256 related definitions */
+
+prng_state prng_init(uint64_t seed)
+{
+	prng_state state = { .next_word = 0 };
+	uint32_t seed_arr[2] = { seed >> 32, seed };
+
+	sha256_hash(ARRAY_SIZE(seed_arr), &seed_arr, &state.hash);
+	return state;
+}
+
+static void prng_scramble(prng_state *state)
+{
+	uint32_t input[8];
+
+	memcpy(input, state->hash, sizeof(state->hash));
+	sha256_hash(ARRAY_SIZE(input), &input, &state->hash);
+	state->next_word = 0;
+}
+
+uint32_t prng32(prng_state *state)
+{
+	if (state->next_word < ARRAY_SIZE(state->hash))
+		return state->hash[state->next_word++];
+
+	prng_scramble(state);
+	return prng32(state);
+}
+
+uint64_t prng64(prng_state *state)
+{
+	/* explicitly evaluate the high word first */
+	uint64_t high = prng32(state);
+
+	return high << 32 | prng32(state);
+}
-- 
2.44.0


