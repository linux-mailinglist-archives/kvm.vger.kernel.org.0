Return-Path: <kvm+bounces-5793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E55826A13
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 10:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 001D5B21FF0
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 09:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D24F1170D;
	Mon,  8 Jan 2024 09:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LRqu0Bde"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAB3DDB2
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 09:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 8 Jan 2024 10:02:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704704533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IRugJM0GRV//PjdRdHm8SZSE3x5dyDsNJ0Pv76IThdY=;
	b=LRqu0Bde0zPtpgKeGRJ7D3eG7zw85dcwymBFeKGo9oj0YXQ+PNGJUBgGbbo74al3fcLioW
	0kAwGRb++TQO6uwzcOufFqr9nW6fljzsHb8tZDDuhIbVMmWI324CMkQqpsQKRoP6LLnwcF
	IeTsGBBIqrGntN1GLwZDgvG3UbYV84g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/5] lib: Add pseudo random functions
Message-ID: <20240108-c38dbfc426dcfa7f59ac825f@orel>
References: <20240105225419.2841310-1-nsg@linux.ibm.com>
 <20240105225419.2841310-2-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240105225419.2841310-2-nsg@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 05, 2024 at 11:54:15PM +0100, Nina Schoetterl-Glausch wrote:
> Add functions for generating pseudo random 32 and 64 bit values.
> The implementation uses SHA-256 and so the randomness should have good
> quality.
> Implement the necessary subset of SHA-256.
> The PRNG algorithm is equivalent to the following python snippet:
> 
> def prng32(seed):
>     from hashlib import sha256
>     state = seed.to_bytes(8, byteorder="big")
>     while True:
>         state = sha256(state).digest()
>         for i in range(8):
>             yield int.from_bytes(state[i*4:(i+1)*4], byteorder="big")
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
> 
> Notes:
>     Since a PRNG with better quality was asked for I decided to use SHA-256
>     because:
>      * it is a standard, commonly used algorithm
>      * high quality randomness is assured
>      * the implementation can be checked against the spec
>      * the implementation can be easily checked via comparison
>     
>     I tested the implementation in the following way:
>     
>     cat <<'EOF' > rand.py
>     #!/usr/bin/python3
>     
>     def prng32(seed):
>         from hashlib import sha256
>         state = seed.to_bytes(8, byteorder="big")
>         while True:
>             state = sha256(state).digest()
>             for i in range(8):
>                 yield int.from_bytes(state[i*4:(i+1)*4], byteorder="big")
>     
>     r = prng32(0)
>     for i in range(100):
>         print(f"{next(r):08x}")
>     
>     EOF
>     
>     cat <<'EOF' > rand.c
>     #include <stdio.h>
>     #include "rand.h"
>     
>     void main(void)
>     {
>     	prng_state state = prng_init(0);
>     	for (int i = 0; i < 100; i++) {
>     		printf("%08x\n", prng32(&state));
>     	}
>     }
>     EOF
>     cat <<'EOF' > libcflat.h
>     #define ARRAY_SIZE(_a) (sizeof(_a)/sizeof((_a)[0]))
>     EOF
>     chmod +x rand.py
>     ln -s lib/rand.c librand.c
>     gcc -Ilib librand.c rand.c
>     diff <(./a.out) <(./rand.py)
> 
>  Makefile   |   1 +
>  lib/rand.h |  21 +++++++
>  lib/rand.c | 177 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 199 insertions(+)
>  create mode 100644 lib/rand.h
>  create mode 100644 lib/rand.c
> 
> diff --git a/Makefile b/Makefile
> index 602910dd..7997e035 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -28,6 +28,7 @@ cflatobjs := \
>  	lib/printf.o \
>  	lib/string.o \
>  	lib/abort.o \
> +	lib/rand.o \
>  	lib/report.o \
>  	lib/stack.o
>  
> diff --git a/lib/rand.h b/lib/rand.h
> new file mode 100644
> index 00000000..cdce8bd7
> --- /dev/null
> +++ b/lib/rand.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * (pseudo) random functions
> + *
> + * Copyright IBM Corp. 2024
> + */
> +#ifndef _RAND_H_
> +#define _RAND_H_
> +
> +#include <stdint.h>
> +
> +/* Non cryptographically secure PRNG */
> +typedef struct {
> +	uint32_t hash[8];
> +	uint8_t next_word;
> +} prng_state;
> +prng_state prng_init(uint64_t seed);
> +uint32_t prng32(prng_state *state);
> +uint64_t prng64(prng_state *state);
> +
> +#endif /* _RAND_H_ */
> diff --git a/lib/rand.c b/lib/rand.c
> new file mode 100644
> index 00000000..c5b3d53c
> --- /dev/null
> +++ b/lib/rand.c
> @@ -0,0 +1,177 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * (pseudo) random functions
> + * Currently uses SHA-256 to scramble the PRNG state.
> + *
> + * Copyright IBM Corp. 2024
> + */
> +
> +#include "libcflat.h"
> +#include "rand.h"
> +#include <string.h>
> +
> +/* Begin SHA-256 related definitions */
> +
> +#define INITAL_HASH { \
> +	0x6a09e667, \
> +	0xbb67ae85, \
> +	0x3c6ef372, \
> +	0xa54ff53a, \
> +	0x510e527f, \
> +	0x9b05688c, \
> +	0x1f83d9ab, \
> +	0x5be0cd19, \
> +}
> +
> +static const uint32_t K[] = {
> +	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
> +	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
> +	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
> +	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
> +	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
> +	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
> +	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
> +	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
> +};
> +
> +static inline uint32_t ch(uint32_t x, uint32_t y, uint32_t z)
> +{
> +	return (x & y) ^ ((~x) & z);
> +}
> +
> +static inline uint32_t maj(uint32_t x, uint32_t y, uint32_t z)
> +{
> +	return (x & y) ^ (x & z) ^ (y & z);
> +}
> +
> +static inline uint32_t rot(uint32_t value, unsigned int count)
> +{
> +	return value >> count | value << (32 - count);
> +}
> +
> +static inline uint32_t upper_sig0(uint32_t x)
> +{
> +	return rot(x, 2) ^ rot(x, 13) ^ rot(x, 22);
> +}
> +
> +static inline uint32_t upper_sig1(uint32_t x)
> +{
> +	return rot(x, 6) ^ rot(x, 11) ^ rot(x, 25);
> +}
> +
> +static inline uint32_t lower_sig0(uint32_t x)
> +{
> +	return rot(x, 7) ^ rot(x, 18) ^ (x >> 3);
> +}
> +
> +static inline uint32_t lower_sig1(uint32_t x)
> +{
> +	return rot(x, 17) ^ rot(x, 19) ^ (x >> 10);
> +}
> +
> +enum alphabet { a, b, c, d, e, f, g, h, };
> +
> +static void sha256_chunk(const uint32_t (*chunk)[16], uint32_t (*hash)[8])
> +{
> +	uint32_t w[64];
> +	uint32_t w_hash[8];
> +
> +	memcpy(w, chunk, sizeof(*chunk));
> +
> +	for (int i = 16; i < 64; i++)
> +		w[i] = lower_sig1(w[i - 2]) + w[i - 7] + lower_sig0(w[i - 15]) + w[i - 16];
> +
> +	memcpy(w_hash, hash, sizeof(*hash));
> +
> +	for (int i = 0; i < 64; i++) {
> +		uint32_t t1, t2;
> +
> +		t1 = w_hash[h] +
> +		     upper_sig1(w_hash[e]) +
> +		     ch(w_hash[e], w_hash[f], w_hash[g]) +
> +		     K[i] +
> +		     w[i];
> +
> +		t2 = upper_sig0(w_hash[a]) + maj(w_hash[a], w_hash[b], w_hash[c]);
> +
> +		w_hash[h] = w_hash[g];
> +		w_hash[g] = w_hash[f];
> +		w_hash[f] = w_hash[e];
> +		w_hash[e] = w_hash[d] + t1;
> +		w_hash[d] = w_hash[c];
> +		w_hash[c] = w_hash[b];
> +		w_hash[b] = w_hash[a];
> +		w_hash[a] = t1 + t2;
> +	}
> +
> +	for (int i = 0; i < 8; i++)
> +		(*hash)[i] += w_hash[i];
> +}
> +
> +/**
> + * sha256_hash - Calculate SHA-256 of input. Only a limited subset of inputs supported.
> + * @n: Number of words to hash, must be <= 13
> + * @input: Input data to hash
> + * @hash: Output hash as a word array, ordered such that the first word contains
> + *        the first/leftmost bits of the 256 bit hash
> + *
> + * Calculate the SHA-256 hash of the input where the input must be a multiple of
> + * 4 bytes and at most 52 long. The input is used without any adjustment, so,
> + * should the caller want to hash bytes it needs to interpret the bytes in the
> + * ordering as defined by the specification, that is big endian.
> + * The same applies to interpreting the output array as bytes.
> + * The function computes the same as: printf "%08x" ${input[@]} | xxd -r -p | sha256sum .
> + */
> +static void sha256_hash(unsigned int n, const uint32_t (*input)[n], uint32_t (*hash)[8])
> +{
> +	/*
> +	 * Pad according to SHA-2 specification.
> +	 * First set up length in bits.
> +	 */
> +	uint32_t chunk[16] = {
> +		[15] = sizeof(*input) * 8,
> +	};
> +
> +	memcpy(chunk, input, sizeof(*input));
> +	/* Then add separator */
> +	chunk[n] = 1 << 31;
> +	memcpy(hash, (uint32_t[])INITAL_HASH, sizeof(*hash));
> +	sha256_chunk(&chunk, hash);
> +}
> +
> +/* End SHA-256 related definitions */
> +
> +prng_state prng_init(uint64_t seed)
> +{
> +	prng_state state = { .next_word = 0 };
> +	uint32_t seed_arr[2] = { seed >> 32, seed };
> +
> +	sha256_hash(ARRAY_SIZE(seed_arr), &seed_arr, &state.hash);
> +	return state;
> +}
> +
> +static void prng_scramble(prng_state *state)
> +{
> +	uint32_t input[8];
> +
> +	memcpy(input, state->hash, sizeof(state->hash));
> +	sha256_hash(ARRAY_SIZE(input), &input, &state->hash);
> +	state->next_word = 0;
> +}
> +
> +uint32_t prng32(prng_state *state)
> +{
> +	if (state->next_word < ARRAY_SIZE(state->hash))
> +		return state->hash[state->next_word++];
> +
> +	prng_scramble(state);
> +	return prng32(state);
> +}
> +
> +uint64_t prng64(prng_state *state)
> +{
> +	/* explicitly evaluate the high word first */
> +	uint64_t high = prng32(state);
> +
> +	return high << 32 | prng32(state);
> +}
> -- 
> 2.43.0
>

LGTM,

Acked-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

